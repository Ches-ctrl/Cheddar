class JobsTechnologies < ActiveRecord::Migration[7.1]
  def change
    create_join_table :jobs, :technologies
  end
end
