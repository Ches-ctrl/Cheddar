require 'open-uri'

class ApplicationService
  def page_doc(url)
    # url = 'https://www.monster.com/jobs/q-it-jobs'
    data = URI.parse(url).open
    Nokogiri::XML(data)
  end
end
