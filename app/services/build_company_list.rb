class BuildCompanyList
  extend CheckUrlIsValid

  def self.complete_list
    headers = ['name', 'ats', 'ats_identifier', 'description', 'url_website', 'url_careers', 'url_linkedin', 'url_ats_main', 'url_ats_api', 'location', 'industry', 'sub-industry', 'total_live', 'carbon_pledge']
    company_csv_filepath = Rails.root.join('storage', 'csv', 'company_details.csv')

    puts "Starting to build list..."

    CSV.open(company_csv_filepath, 'w') do |csv|
      csv << headers
    end

    Company.includes(:applicant_tracking_system).all.each do |company|
      details = [
        company.name,
        company.applicant_tracking_system.name,
        company.ats_identifier,
        company.description,
        company.website_url,
        company.url_careers,
        company.url_linkedin,
        company.url_ats_main,
        company.url_ats_api,
        company.location,
        company.industry,
        company.industry_subcategory,
        company.total_live,
        company.carbon_pledge
      ]
      CSV.open(company_csv_filepath, 'a') do |csv|
        csv << details
      end
    end
    puts "Finished building list."
  end

  def self.call
    ats_identifiers_filepath = Rails.root.join('storage', 'csv', 'ats_identifiers.csv')
    # company_csv_filepath = Rails.root.join('storage', 'csv', 'company_names_and_websites.csv')
    invalid_ids_filepath = Rails.root.join('storage', 'csv', 'invalid_ids.csv')
    # headers = ['name', 'website']
    headers = ['ats,ats_identifier']

    puts "Starting to build list..."

    CSV.open(invalid_ids_filepath, 'w') do |csv|
      csv << headers
    end

    CSV.foreach(ats_identifiers_filepath, headers: true) do |row|
      ats_identifier = row['ats_identifier']
      next if Company.find_by(ats_identifier:)

      ats_name = row['ats']
      p "ATS: #{ats_name}"
      ats = ApplicantTrackingSystem.find_by(name: ats_name)
      company = ats.find_or_create_company(ats_identifier)
      p "trying to create company with id: #{ats_identifier}"
      unless company&.persisted?
        CSV.open(invalid_ids_filepath, 'a') do |csv|
          csv << [ats_name, ats_identifier]
        end
      end

      details = [
        company.name,
        company.website_url
      ].compact
      puts "Company name: #{details[0]}, Website: #{details[1]}"

    #   CSV.open(company_csv_filepath, 'a') do |csv|
    #     csv << details
    #   end
    # end

    # puts "Finished with the companies in ats_identifiers.csv."

    # handle DevITJobs
    # puts "\nAdding companies from DevITJobs."

    # ats = ApplicantTrackingSystem.find_by(name: 'DevITJobs')
    # url = ats.url_all_jobs
    # company_info = Set.new

    # response = get(url)
    # all_jobs_data = JSON.parse(response)
    # all_jobs_data.each do |job_data|
    #   puts "trying to create company with id: #{job_data['company']}"
    #   company = ats.find_or_create_company_by_data(job_data)
    #   puts "#{company.company_name} created." if company.persisted?
    end

    # all_jobs_data.each do |job|
    #   details = [
    #     job['company'],
    #     job['companyWebsiteLink']
    #   ].compact
    #   puts "Company name: #{details[0]}, Website: #{details[1]}"
    #   company_info << details
    # end
    # CSV.open(company_csv_filepath, 'a') do |csv|
    #   company_info.each do |company|
    #     csv << company
    #   end
    # end

    puts "Finished building list."
  end
end
