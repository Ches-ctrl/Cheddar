module HashBuilder
  extend ActiveSupport::Concern
  include CompanyCsv

  def build_ats_companies
    {
      greenhouse: load_from_csv('greenhouse'),
      lever: load_from_csv('lever'),
      workable: load_from_csv('workable'),
      ashbyhq: load_from_csv('ashbyhq'),
      pinpointhq: load_from_csv('pinpointhq'),
      bamboohr: load_from_csv('bamboohr'),
      recruitee: load_from_csv('recruitee'),
      manatal: load_from_csv('manatal'),
    }
  end

  def build_relevant_descriptions
    descriptions = Hash.new { |hash, key| hash[key] = [] }

    filepath = 'storage/relevant_jobs.csv'
    CSV.foreach(filepath) do |row|
      company_id, job_title, job_description, inferred_seniority = row
      descriptions[company_id] << [company_id, job_title, job_description, inferred_seniority]
    end

    return descriptions
  end
end
