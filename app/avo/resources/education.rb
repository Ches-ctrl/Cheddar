module Avo
  module Resources
    class Education < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :university, as: :text
        field :degree, as: :text
        field :field_study, as: :text
        field :graduation_year, as: :number
        field :user_id, as: :number
        field :user, as: :belongs_to
      end
    end
  end
end
