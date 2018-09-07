# This comes from https://github.com/alphagov/govuk-developer-docs
require 'html/pipeline'
require 'uri'
require_relative 'http'

class ExternalDoc
  def self.fetch(repository:, path:, exclude_headings: [])
    contents = HTTP.get(
      "https://raw.githubusercontent.com/#{repository}/master/#{path}",
    ).force_encoding(Encoding::UTF_8)

    context = {
      # Turn off hardbreaks as they behave different to github rendering
      gfm: false,
      base_url: URI.join(
        'https://github.com',
        "#{repository}/blob/master/",
      ),

      image_base_url: URI.join(
        'https://raw.githubusercontent.com',
        "#{repository}/master/",
      ),
    }

    context[:subpage_url] =
      URI.join(context[:base_url], File.join('.', File.dirname(path), '/'))

    context[:image_subpage_url] =
      URI.join(context[:image_base_url], File.join('.', File.dirname(path), '/'))

    filters = [
      HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::AbsoluteSourceFilter,
      SurroundingContextFilter,
      HeadingFilter,
      AbsoluteLinkFilter,
      MarkdownLinkFilter,
      ReplaceH1WithH2,
    ]

    HTML::Pipeline
      .new(filters)
      .to_html(contents, context)
  end

  # When we import external documentation it can contain relative links to
  # source files within the repository that the documentation resides. We need
  # to filter out these types of links and make them absolute so that they
  # continue to work when rendered as part of this site.
  #
  # For example a link to `lib/link_expansion.rb` would be rewritten to
  # https://github.com/alphagov/publishing-api/blob/master/lib/link_expansion.rb
  class AbsoluteLinkFilter < HTML::Pipeline::Filter
    def call
      doc.search('a').each do |element|
        next if element['href'].nil? || element['href'].empty?

        href = element['href'].strip
        uri = URI.parse(href)
        path = uri.path

        unless uri.scheme || href.start_with?('#') || path.end_with?('.md')
          base = if path.start_with? '/'
                   base_url
                 else
                   subpage_url
                 end

          element['href'] = URI.join(base, href).to_s
        end
      end

      doc
    end

    def subpage_url
      context[:subpage_url]
    end
  end

  # When we import external documentation formatted with Markdown it can
  # contain links to other pages of documentation also formatted with Markdown.
  # When the documentation is rendered as part of GOV.UK Developer Docs we
  # render it as HTML so we need to rewrite the links so that they have a .html
  # extension to match out routing.
  #
  # For example a link to `link-expansion.md` would be rewritten to
  # `link-expansion.html`
  class MarkdownLinkFilter < HTML::Pipeline::Filter
    def call
      doc.search('a').each do |element|
        next if element['href'].nil? || element['href'].empty?

        href = element['href'].strip
        uri = URI.parse(href)

        if uri.path.end_with?('.md')
          uri.path.sub!(/.md$/, '.html')
          element['href'] = uri.to_s
        end
      end

      doc
    end
  end

  # Any other H1s should be considered H2s
  class ReplaceH1WithH2 < HTML::Pipeline::Filter
    def call
      doc.css('h1').each do |node|
        h2 = doc.document.create_element("h2", node.attributes)
        h2.inner_html = node.inner_html
        node.replace(h2)
      end

      doc
    end
  end

  # This adds a unique ID to each header element so that we can reference
  # each section of the document when we build our table of contents navigation.
  class HeadingFilter < HTML::Pipeline::Filter
    def call
      headers = Hash.new(0)

      doc.css('h1, h2, h3, h4, h5, h6').each do |node|
        text = node.text
        id = text
               .downcase # lower case
               .gsub(/<[^>]*>/, '') # crudely remove html tags
               .gsub(/[^\w\- ]/, '') # remove any non-word characters
               .tr(' ', '-') # replace spaces with hyphens

        headers[id] += 1

        if node.children.first
          node[:id] = id
        end
      end

      doc
    end
  end

  class SurroundingContextFilter < HTML::Pipeline::Filter
    def headings
      %w(h1 h2 h3 h4 h5)
    end

    def heading_level(node_name)
      case node_name
      when "h1"
        2 # We're going to pretend h1 is actually h2, so we remove intro text, but not subheadings
      when "h2"
        2
      when "h3"
        3
      when "h4"
        4
      when "h5"
        5
      else
        6 # includes non-headings
      end
    end

    def remove_section(from_node)
      section_level = heading_level(from_node.name)

      sibling = from_node.next_sibling

      until sibling.nil? || heading_level(sibling.name) <= section_level
        next_sibling = sibling.next_sibling
        sibling.remove
        sibling = next_sibling
      end

      from_node.remove
    end

    def call
      doc.css(*headings).each do |node|
        if node.text =~ /licen[cs]e/i
          remove_section(node)
        end
      end

      first_h1 = doc.at('h1:first-of-type')
      remove_section(first_h1) unless first_h1.nil?

      doc
    end
  end
end