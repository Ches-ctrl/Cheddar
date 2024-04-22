module Avo
  module Resources
    class ApplicantTrackingSystem < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :name, as: :text
        field :url_website, as: :text
        field :url_base, as: :text
        field :base_url_api, as: :text
        field :all_jobs_url, as: :text
        field :companies, as: :has_many
        field :jobs, as: :has_many
      end
    end
  end
end
