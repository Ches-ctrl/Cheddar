class DropUserDetailFieldsFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :phone_number, :string
    remove_column :users, :preferred_pronoun_text, :string
    remove_column :users, :preferred_pronoun_select, :string
    remove_column :users, :address_first, :string
    remove_column :users, :address_second, :string
    remove_column :users, :post_code, :string
    remove_column :users, :city, :string
    remove_column :users, :website_url, :string
    remove_column :users, :github_profile_url, :string
    remove_column :users, :linkedin_profile, :string
    remove_column :users, :notice_period, :integer
    remove_column :users, :right_to_work, :string
    remove_column :users, :salary_expectation_figure, :integer
    remove_column :users, :salary_expectation_text, :string
    remove_column :users, :employee_referral, :string
    remove_column :users, :cover_letter_template_url, :string

  end
end
