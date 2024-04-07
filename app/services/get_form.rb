class GetForm
  require 'net/http'
  require 'json'

  def self.perform
    url = URI("https://boards-api.greenhouse.io/v1/boards/codepath/jobs/4035993007?questions=true&pay_transparency=true")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)
    response = http.request(request)

    if response.code == '200'
      data = JSON.parse(response.body)
      questions = data['questions']
      location_questions = data['location_questions']
      demographic_questions = data['demographic_questions']
      p location_questions.first
      p demographic_questions
      p "----"
      p questions
    else
      puts "Failed to retrieve the form. Error: #{response.code} - #{response.message}"
    end
  end
end
