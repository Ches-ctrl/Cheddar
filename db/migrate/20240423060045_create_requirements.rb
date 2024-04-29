class CreateRequirements < ActiveRecord::Migration[7.1]
  def change
    create_table :requirements do |t|
      t.references :job, foreign_key: true
      t.boolean "work_eligibility"
      t.string "difficulty"
      t.integer "no_of_qs", default: 0
      t.boolean "create_account", default: false
      t.boolean "resume", default: true
      t.boolean "cover_letter", default: false
      t.boolean "video_interview", default: false
      t.boolean "online_assessment", default: false
      t.boolean "first_round", default: true
      t.boolean "second_round", default: true
      t.boolean "third_round", default: false
      t.boolean "assessment_centre", default: false

      t.timestamps
    end
  end
end
