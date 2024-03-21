module Avo
  module Resources
    class Message < Avo::BaseResource
      self.includes = []
      # self.search = {
      #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
      # }

      def fields
        field :id, as: :id
        field :content, as: :textarea
        field :self, as: :boolean
      end
    end
  end
end
