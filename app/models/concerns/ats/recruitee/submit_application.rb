module Ats
  module Recruitee
    module SubmitApplication
      private

      def submit_application
        puts "Here's the form:"
        p form_data
        submit_form(form_data)
      end

      def form_data
        form_data = []
        index = 0
        @fields.each_value do |field|
          field_value = field['value'] # what about multi-content?
          field_id, field_type = field['locators'].split(':')
          multi_index = field_type == 'multi_content' ? "[]" : ""
          if field['core_field']
            form_data << ["candidate[#{field_id}]", field_value.instance_of?(String) ? field_value : create_tmp_file(field_id, field_value)]
          else
            form_data << ["candidate[open_question_answers_attributes][#{index}][open_question_id]", field_id]
            form_data << ["candidate[open_question_answers_attributes][#{index}][#{field_type}]#{multi_index}", field_value]
            index += 1
          end
        end
        form_data
      end

      def submit(form_data)
        base_url = @job.company.url_ats_api
        offer_slug = @job.ats_job_id
        url = "#{base_url}#{offer_slug}/candidates"

        response = HTTParty.post(
          url,
          headers: { 'Content-Type' => 'multipart/form-data' },
          multipart: form_data
        )

        if response.success?
          puts "Form submitted successfully. Here's the JSON response:"
          puts JSON.parse(response.body)
        else
          puts "Form submission failed:"
          puts response.body
        end
      end

      def submit_form(form_data)
        base_url = @job.company.url_ats_api
        offer_slug = @job.ats_job_id
        posting = "#{base_url}#{offer_slug}/candidates"
        url = URI(posting)

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request.set_form form_data, 'multipart/form-data'
        response = https.request(request)

        process_response(response)
      end

      def process_response(response)
        puts "Here's the response:"
        puts response
        puts response_body = response.read_body

        if response.is_a?(Net::HTTPUnprocessableEntity)
          response_data = JSON.parse(response_body)
          response_data['error'].each do |error|
            puts "Encountered the following error: #{error}"
          end
          response_data['error_fields'].each do |field, errors|
            puts "Problem with #{field}:"
            errors.each { |error| puts error }
          end
        end
      end

      def submit_method(form_data)
        url = URI("https://grid.recruitee.com/api/offers/cloud-platform-engineer/candidates")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        form_data = [
          ['candidate[name]', 'Jane Doe'],
          ['candidate[email]', 'jane@example.com'],
          ['candidate[cover_letter]', 'Example cover letter'],
          ['candidate[cv]', File.open(Rails.root.join('tmp', "Resume - #{@user.first_name} #{@user.last_name} - #{@job.title} - #{@job.company.name}.pdf"))],
          ['candidate[open_question_answers_attributes][0][open_question_id]', '2516269'],
          ['candidate[open_question_answers_attributes][0][content]', 'hello'],
          ['candidate[open_question_answers_attributes][1][open_question_id]', '2516270'],
          ['candidate[open_question_answers_attributes][1][content]', 'Example answer - text (multiple lines) type'],
          ['candidate[open_question_answers_attributes][2][open_question_id]', '2516271'],
          ['candidate[open_question_answers_attributes][2][content]', 'Prefer Not to Answer'],
          ['candidate[open_question_answers_attributes][3][open_question_id]', '2516272'],
          ['candidate[open_question_answers_attributes][3][content]', 'Example answer - single choice type'],
          ['candidate[open_question_answers_attributes][4][open_question_id]', '2516273'],
          ['candidate[open_question_answers_attributes][4][flag]', 'true'],
          ['candidate[open_question_answers_attributes][5][open_question_id]', '2516274'],
          ['candidate[open_question_answers_attributes][5][content]', 'Hooray'],
          ['candidate[open_question_answers_attributes][6][open_question_id]', '2516284'],
          ['candidate[open_question_answers_attributes][6][content]', 'Yes!'],
          ['candidate[open_question_answers_attributes][7][open_question_id]', '2516285'],
          ['candidate[open_question_answers_attributes][7][content]', 'Okay'],
          ['candidate[open_question_answers_attributes][8][open_question_id]', '2516287'],
          ['candidate[open_question_answers_attributes][8][content]', 'Yes, excellent']
        ]
        request.set_form form_data, 'multipart/form-data'
        response = https.request(request)
        puts response.read_body
      end

      def fetch_file(file)
        service = file.service
        file_key = file.key
        service.download(file_key)
      end

      def create_tmp_file(filetype, file)
        puts "THE FILETYPE IS #{filetype}"
        convert = {
          'photo' => '.jpg',
          'cv' => '.pdf',
          'cover_letter' => '.docx'
        }
        file_path = Rails.root.join('tmp', "#{filetype} - #{@user.first_name} #{@user.last_name} - #{@job.title} - #{@job.company.name}#{convert[filetype]}")
        File.binwrite(file_path, URI.open(file.url).read)
        File.open(file_path)
      end
    end
  end
end
# if file.instance_of?(String)
#   docx = Htmltoword::Document.create(file)
#   file_path = Rails.root.join('tmp',
#                               "Cover Letter - #{@job.title} - #{@job.company.name} - #{@user.first_name} #{@user.last_name}.docx")
#   File.binwrite(file_path, docx)
# else
#   file_path = Rails.root.join('tmp', "Resume - #{@user.first_name} #{@user.last_name} - #{@job.title} - #{@job.company.name}.pdf")
#   File.binwrite(file_path, URI.open(file.url).read)
# end

# ["candidate[name]"]=>"asdfsdf",
# ["candidate[email]"]=>"admin@getcheddar.xyz",
# ["candidate[phone]"]=>"asdf",
# ["candidate[photo]"]=>#<ActiveStorage::Attached::One:0x000000010e1e1090 @name="photo", @record=#<User id: 1703, email: "admin@getcheddar.xyz", created_at: "2024-04-29 08:48:26.012325000 +0000", updated_at: "2024-05-07 12:33:53.377983000 +0000", first_name: "Charlotte", last_name: "Boyd", linkedin_profile: "", address_first: "14 Knapp Drive", address_second: "", post_code: "", city: "London", phone_number: "", github_profile_url: "", website_url: "", cover_letter_template_url: nil, admin: true, salary_expectation_text: "£30,000 - £40,000", right_to_work: "", salary_expectation_figure: 30000, notice_period: 12, preferred_pronoun_select: "He/Him", preferred_pronoun_text: "", employee_referral: "no">>,
# ["candidate[cover_letter]"]=>"Write from Scratch",
# ["candidate[cv]"]=>#<ActiveStorage::Attached::One:0x000000010e2609a8 @name="resume", @record=#<User id: 1703, email: "admin@getcheddar.xyz", created_at: "2024-04-29 08:48:26.012325000 +0000", updated_at: "2024-05-07 12:33:53.377983000 +0000", first_name: "Charlotte", last_name: "Boyd", linkedin_profile: "", address_first: "14 Knapp Drive", address_second: "", post_code: "", city: "London", phone_number: "", github_profile_url: "", website_url: "", cover_letter_template_url: nil, admin: true, salary_expectation_text: "£30,000 - £40,000", right_to_work: "", salary_expectation_figure: 30000, notice_period: 12, preferred_pronoun_select: "He/Him", preferred_pronoun_text: "", employee_referral: "no">>,
# ["[open_question_answers_attributes][1][open_question_id]=759621", "[open_question_answers_attributes][1][content]="]=>"me",
# ["[open_question_answers_attributes][2][open_question_id]=749891", "[open_question_answers_attributes][2][content]="]=>"DuckDuckGo Search",
# ["[open_question_answers_attributes][3][open_question_id]=1535391", "[open_question_answers_attributes][3][content]="]=>"foo",
# ["[open_question_answers_attributes][4][open_question_id]=749897", "[open_question_answers_attributes][4][content]="]=>"bar",
# ["[open_question_answers_attributes][5][open_question_id]=749892", "[open_question_answers_attributes][5][content]="]=>"hello",
# ["[open_question_answers_attributes][6][open_question_id]=749898", "[open_question_answers_attributes][6][content]="]=>"world?",
# ["[open_question_answers_attributes][7][open_question_id]=749899", "[open_question_answers_attributes][7][content]="]=>"Here",
# ["[open_question_answers_attributes][8][open_question_id]=1775988", "[open_question_answers_attributes][8][content]="]=>"Not Applicable (I will not be working in the United States)",
# ["[open_question_answers_attributes][9][open_question_id]=1775991", "[open_question_answers_attributes][9][content]="]=>"Yes"}
