module Avo
  module Resources
    class Job < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        # field :id, as: :id
        field :title, as: :text
        field :description, as: :text
        field :salary, as: :number
        # field :date_posted, as: :date
        field :deadline, as: :date
        field :posting_url, as: :text
        field :company_id, as: :number
        field :applicant_tracking_system_id, as: :number
        # field :responsibilities, as: :textarea
        # field :requirements, as: :textarea
        # field :benefits, as: :textarea
        # field :employment_type, as: :text
        field :location, as: :text
        field :country, as: :country
        field :industry, as: :text
        field :seniority, as: :text
        field :applicants_count, as: :number
        field :cheddar_applicants_count, as: :number
        field :bonus, as: :number
        field :sub_industry, as: :text
        field :live, as: :boolean
        field :ats_job_id, as: :text
        field :company, as: :belongs_to
        field :applicant_tracking_system, as: :belongs_to
        field :job_applications, as: :has_many
        field :saved_jobs, as: :has_many
      end
    end
  end
end
