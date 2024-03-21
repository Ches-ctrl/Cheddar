require 'open-uri'

class ApplicationService
  # rubocop:disable Security/Open
  def page_doc(url)
    # url = 'https://www.monster.com/jobs/q-it-jobs'
    data = URI.open(url).read
    Nokogiri::HTML(data)
  end
  # rubocop:enable Security/Open
end
