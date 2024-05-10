module Ats
  module Recruitee
    module SubmitApplication
      private

      def submit_application
        submit_form(form_data)
      end

      def form_data
        form_data = []
        index = 0
        @fields.each_value do |field|
          field_value = field['value']
          field_id, field_type = field['locators'].split(':')
          multi_index = field_type == 'multi_content' ? "[]" : ""
          if field['core_field']
            # TODO: fix not currently creating tmp_files for cover letters, since they're passed as strings
            form_data << ["candidate[#{field_id}]", field_value.instance_of?(String) ? field_value : create_tmp_file(field_id, field_value)]
          else
            form_data << ["candidate[open_question_answers_attributes][#{index}][open_question_id]", field_id]
            form_data << ["candidate[open_question_answers_attributes][#{index}][#{field_type}]#{multi_index}", field_value]
            index += 1
          end
        end
        form_data
      end

      def submit_form(form_data)
        # TODO: use HTTParty for better security?
        url = build_url

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request.set_form form_data, 'multipart/form-data'
        response = https.request(request)

        process_response(response)
      end

      def build_url
        base_url = @job.company.url_ats_api
        offer_slug = @job.ats_job_id
        posting = "#{base_url}#{offer_slug}/candidates"
        URI(posting)
      end

      def process_response(response)
        puts "Here's the response:"
        puts response
        puts response_body = response.read_body
        if response.is_a?(Net::HTTPCreated)
          puts "Application was successfully submitted!"
        elsif response.is_a?(Net::HTTPUnprocessableEntity)
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

      def create_tmp_file(filetype, file)
        puts "THE FILETYPE IS #{filetype}"
        convert = {
          'photo' => '.jpg',
          'cv' => '.pdf',
          'cover_letter' => '.docx'
        }
        file_path = Rails.root.join('tmp', "#{filetype} - #{@user.first_name} #{@user.last_name} - #{@job.title} - #{@job.company.name}#{convert[filetype]}")
        File.binwrite(file_path, URI.parse(file.url).open.read)
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
