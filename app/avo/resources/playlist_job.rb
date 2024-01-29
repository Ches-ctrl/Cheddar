class Avo::Resources::PlaylistJob < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :job_id, as: :number
    field :job_playlist_id, as: :number
    field :job, as: :belongs_to
    field :job_playlist, as: :belongs_to
  end
end
