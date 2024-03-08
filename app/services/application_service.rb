require 'open-uri'

class ApplicationService
  def page_doc(url)
    # url = 'https://www.monster.com/jobs/q-it-jobs'
    data = URI.open(url).read
    Nokogiri::HTML(data)
  end
end
