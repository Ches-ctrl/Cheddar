class Avo::Resources::JobPlaylist < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :playlist_jobs, as: :has_many
    field :jobs, as: :has_many, through: :playlist_jobs
  end
end
