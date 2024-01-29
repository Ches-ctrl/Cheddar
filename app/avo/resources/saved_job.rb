class Avo::Resources::SavedJob < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :job_id, as: :number
    field :user, as: :belongs_to
    field :job, as: :belongs_to
  end
end
