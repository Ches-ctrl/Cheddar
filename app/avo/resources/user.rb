class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :email, as: :text
    field :first_name, as: :text
    field :last_name, as: :text
    field :linkedin_profile, as: :text
    field :address_first, as: :text
    field :address_second, as: :text
    field :post_code, as: :text
    field :city, as: :text
    field :phone_number, as: :text
    field :github_profile_url, as: :text
    field :website_url, as: :text
    field :cover_letter_template_url, as: :text
    field :admin, as: :boolean
    field :salary_expectation_text, as: :text
    field :right_to_work, as: :text
    field :salary_expectation_figure, as: :number
    field :notice_period, as: :number
    field :preferred_pronoun_select, as: :text
    field :preferred_pronoun_text, as: :text
    field :employee_referral, as: :text
    field :photo, as: :file
    field :resume, as: :file
    field :job_applications, as: :has_many
    field :jobs, as: :has_many, through: :job_applications
    field :saved_jobs, as: :has_many
    field :educations, as: :has_many
  end
end
