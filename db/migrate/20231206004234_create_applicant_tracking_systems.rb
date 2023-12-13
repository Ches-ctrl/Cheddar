class CreateApplicantTrackingSystems < ActiveRecord::Migration[7.1]
  def change
    create_table :applicant_tracking_systems do |t|
      t.string :name

      t.timestamps
    end
  end
end
