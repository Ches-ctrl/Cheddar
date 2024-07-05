module Builders
  class UserBuilder
    attr_reader :user_csv

    def initialize
      @user_csv = 'storage/csv/sample_users.csv'
    end

    def build
      CSV.foreach(@user_csv, headers: true) do |row|
        email = process_env_variables(row['email'])
        password = process_env_variables(row['password'])

        user_data = {
          first_name: row["first_name"],
          last_name: row["last_name"],
          phone_number: row["phone_number"],
          address_first: row["address_first"],
          address_second: row["address_second"],
          post_code: row["post_code"],
          city: row["city"],
          salary_expectation_figure: row["salary_expectation_figure"],
          notice_period: row["notice_period"]
          # salary_expectation_text: row["salary_expectation_text"],
          # employee_referral: row["employee_referral"]
        }
        user_detail = UserDetail.new(user_data)

        user = User.create(
          email: email || row["email"],
          password: password || row["password"],
          admin: row["admin"],
          user_detail:
        )

        if user
          attach_resume(user, row["resume"])
          puts "Created User - #{user.email}"
        else
          puts "Error creating User - #{row['email']}"
        end
      end
      puts User.count
    end

    def process_env_variables(value)
      if value.start_with?('<') && value.end_with?('>')
        env_variable = value[1..-2]
        ENV.fetch(env_variable, nil)
      else
        nil
      end
    end

    def attach_resume(user, resume)
      if File.exist?(resume)
        user.user_detail.resumes.attach(io: File.open(resume), filename: File.basename(resume))
        p "Attached resume - #{resume}"
      else
        p "No resume attached - #{user.email}"
      end
    end
  end
end
