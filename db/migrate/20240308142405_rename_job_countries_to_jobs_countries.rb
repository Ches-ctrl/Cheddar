class RenameJobCountriesToJobsCountries < ActiveRecord::Migration[7.1]
  def change
    rename_table :job_countries, :jobs_countries
  end
end
