module Ats
  module Trueup
    module JobDetails
      include ActionView::Helpers::NumberHelper

      def fetch_id(job_data)
        p "Fetching ID"
        job_data['unique_id']
      end

      def job_url_api(base_url, _company_id, _job_id)
        p "Fetching job URL"
        return base_url
      end

      def job_details(_job, data)
        p "Fetching job details"
        {
          title: data['title'],
          description: build_description(data),
          posting_url: data['url'],
          date_posted: (Date.parse(data['updated_at']) if data['updated_at']),
          salary: build_salary(data),
          non_geocoded_location_string: data['location']
        }
        # associate_technologies(job, data)
      end

      private

      def build_description(data)
        title = data['title']
        company_name = data['company_short']
        business_description = data['business_description_short']
        location = data['location']
        apply_url = data['url']
        "<p>#{company_name}, a #{business_description&.downcase} company, is hiring a #{title} in #{location}.</p><p>To apply, visit <a href=\"#{apply_url}\">#{apply_url}</a>.</p>"
      end

      def build_salary(data)
        # assumes that the salary is listed in GBP

        min = data['salary_range_min']
        max = data['salary_range_max']
        return unless min || max

        salary_low = number_with_delimiter(min)
        salary_high = number_with_delimiter(max)
        salary_low == salary_high ? "£#{salary_low} GBP" : "£#{salary_low} - £#{salary_high} GBP"
      end
    end
  end
end

{
  "job_id"=>"1818f540-831b-4487-8a55-c87fe36080cb",
  "company_id"=>"lemfi",
  "title"=>"Senior Software Engineer- Golang",
  "url"=>"https://lemonade-technology-inc.breezy.hr/p/524f20b229a3-senior-software-engineer-golang",
  "updated_at"=>"2024-07-03T23:36:07.000Z",
  "updated_at_timestamp"=>1720049767,
  "location"=>"United Kingdom (remote)",
  "unique_id"=>"br-lemfi-524f20b229a3",
  "salary_range_min"=>nil,
  "salary_range_max"=>nil,
  "company_url_clean"=>"lemfi.com",
  "company_short"=>"LemFi",
  "company"=>"LemFi",
  "business_description_short"=>"Remittance payments",
  "valuation"=>nil,
  "job_openings_total"=>24,
  "date_founded"=>"2020-01-01T00:00:00.000Z",
  "trajectory_score"=>nil,
  "ai_ready"=>1,
  "sponsored"=>0,
  "promoted"=>0,
  "description_tags"=>["GoLang", "AWS", "PostgreSQL", "Docker", "GitHub"],
  "company_investor_details"=>[{"name"=>"Y Combinator", "url"=>"ycombinator.com", "tag_id"=>"yc"}],
  "company_description_plus"=>["🌱 Early-stage startup", "Total funding $34M", "Last raised 10mo ago ($33M Series A)", "5 yrs old", "110 employees"],
  "ats_ux_warning"=>"",
  "objectID"=>"12479004002",
  "_highlightResult"=>{"title"=>{"value"=>"Senior Software Engineer- Golang", "matchLevel"=>"none", "matchedWords"=>[]}, "company"=>{"value"=>"LemFi", "matchLevel"=>"none", "matchedWords"=>[]}}
}
