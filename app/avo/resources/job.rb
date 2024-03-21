module Avo
  module Resources
    class Job < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        # field :id, as: :id
        field :job_title, as: :text
        # field :job_description, as: :text
        field :salary, as: :number
        # field :date_created, as: :date
        # field :application_criteria, as: :textarea
        field :application_deadline, as: :date
        # field :job_posting_url, as: :text
        field :company_id, as: :number
        field :applicant_tracking_system_id, as: :number
        field :application_details, as: :textarea
        # field :description_long, as: :textarea
        # field :responsibilities, as: :textarea
        # field :requirements, as: :textarea
        # field :benefits, as: :textarea
        field :captcha, as: :boolean
        # field :employment_type, as: :text
        field :location, as: :text
        field :country, as: :country
        field :industry, as: :text
        field :seniority, as: :text
        field :applicants_count, as: :number
        field :cheddar_applicants_count, as: :number
        field :bonus, as: :number
        field :industry_subcategory, as: :text
        field :office_status, as: :text
        field :create_account, as: :boolean
        field :req_cv, as: :boolean
        field :req_cover_letter, as: :boolean
        field :req_video_interview, as: :boolean
        field :req_online_assessment, as: :boolean
        field :req_first_round, as: :boolean
        field :req_second_round, as: :boolean
        field :req_assessment_centre, as: :boolean
        field :live, as: :boolean
        field :ats_job_id, as: :text
        field :ats_format_id, as: :number
        field :company, as: :belongs_to
        field :applicant_tracking_system, as: :belongs_to
        field :job_applications, as: :has_many
        field :saved_jobs, as: :has_many
        field :playlist_jobs, as: :has_many
        field :job_playlists, as: :has_many, through: :playlist_jobs
      end
    end
  end
end
