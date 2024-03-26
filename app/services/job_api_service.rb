require "uri"
require "json"
require "net/http"

# NB. Not yet tested to be working

# TODO: Test API Request
# TODO: Add error handling
# TODO: Add logging
# TODO: Add fields to job table
# TODO: Save data to job table
# TODO: Create company if company doesn't exist
# TODO: Create industry table
# TODO: Evaluate Job vs Service and implications on application performance

class JobApiService
  def fetch_and_save_jobs
    url = URI("https://api.coresignal.com/cdapi/v1/linkedin/job/search/filter")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    p https

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{ENV.fetch('CORESIGNAL_API_KEY', nil)}"
    request.body = JSON.dump(
      { title: "(Full Stack Developer) OR (Full Stack Software Engineer) OR (Full Stack Web Developer)",
        application_active: false, deleted: false, country: "(United Kingdom)", location: "London" }
    )

    p request

    response = https.request(request)
    p response.read_body

    # Parsing the data into json and calling the method to output the jobs
    data = JSON.parse(response.body)
    p data

    create_job_from_api_data(data)
  end

  private

  def create_job_from_api_data(data)
    # Check if data already exists in the database (via unique identifier e.g. external_url)
    return if Job.exists?(external_url: data["external_url"])

    # Create job in jobs table based on external values
    # TODO: update mapping of fields
    Job.create(
      title: data["title"],
      description: data["description"],
      location: data["location"],
      seniority: data["seniority"],
      employment_type: data["employment_type"],
      company_name: data["company_name"],
      company_url: data["company_url"],
      external_url: data["external_url"]
      # Map other fields as necessary
    )
  end
end
