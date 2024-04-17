class CreateJobBoards < ActiveRecord::Migration[7.1]
  def change
    create_table :job_boards do |t|
      t.string :name
      t.string :url_identifier
      t.string :url_website
      t.string :url_base
      t.string :url_api
      t.string :url_all_jobs
      t.string :url_xml
      t.string :url_rss
      t.string :url_linkedin
      t.boolean :login

      t.timestamps
    end
  end
end
