module Avo
  module Resources
    class Company < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :name, as: :text
        field :applicant_tracking_system_id, as: :number
        field :ats_identifier, as: :text
        field :description, as: :textarea
        field :url_website, as: :text
        field :url_careers, as: :text
        field :url_linkedin, as: :text
        field :url_ats_main, as: :text
        field :url_ats_api, as: :text
        field :location, as: :text
        field :industry, as: :text
        field :industry_subcategory, as: :text
        field :total_live, as: :number
        field :applicant_tracking_system, as: :belongs_to
        field :jobs, as: :has_many
      end
    end
  end
end
