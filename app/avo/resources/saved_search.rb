class Avo::Resources::SavedSearch < Avo::BaseResource
  self.includes = [:user, [export_attachment: :blob]]

  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :user_id, as: :number
    field :params, as: :text
    field :user, as: :belongs_to
    field :export, as: :file, link_to_record: true
  end
end
