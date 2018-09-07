require 'govuk_tech_docs'
require 'app/external_doc'
require 'app/manual'

GovukTechDocs.configure(self)

helpers do
  def manual
    Manual.new(sitemap)
  end
end