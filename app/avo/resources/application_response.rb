class Avo::Resources::ApplicationResponse < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :job_application_id, as: :number
    field :field_name, as: :text
    field :field_locator, as: :text
    field :field_value, as: :text
    field :field_option, as: :text
    field :interaction, as: :text
    field :field_options, as: :text
    field :cover_letter_content, as: :text
    field :job_application, as: :belongs_to
  end
end
