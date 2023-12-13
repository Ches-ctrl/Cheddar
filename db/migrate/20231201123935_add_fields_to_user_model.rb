class AddFieldsToUserModel < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :salary_expectation_text, :string
    add_column :users, :right_to_work, :string
    add_column :users, :salary_expectation_figure, :integer
    add_column :users, :notice_period, :integer
    add_column :users, :preferred_pronoun_select, :string
    add_column :users, :preferred_pronoun_text, :string
    add_column :users, :employee_referral, :string
  end
end
