class AddCaptchaBooleanToJob < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :captcha, :boolean
  end
end
