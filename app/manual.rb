class Manual
  attr_reader :sitemap

  def initialize(sitemap)
    @sitemap = sitemap
  end

  def howto_pages
    manual_pages - reference_pages
  end

  def reference_pages
    manual_pages.select { |page| page.data.title =~ /reference/ }
  end

  def manual_pages
    sitemap.resources
      .select { |page| page.path.start_with?('manual/') && page.path.end_with?('.html') && page.data.title }
      .reject { |page| page.path == 'manual/index.html' }
      .sort_by { |page| page.data.title.downcase }
  end
end