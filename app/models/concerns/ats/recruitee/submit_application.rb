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
            form_data << ["candidate[#{field_id}]", field['interaction'] == 'upload' ? build_and_attach_tempfile(field_id, field_value) : field_value]
          else
            form_data << ["candidate[open_question_answers_attributes][#{index}][open_question_id]", field_id]
            form_data << ["candidate[open_question_answers_attributes][#{index}][#{field_type}]#{multi_index}", field_value]
            index += 1
          end
        end
        puts "submitting the following form_data:"
        p form_data
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
        posting = "#{base_url}#{offer_slug}/candidates?async=true"
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

      def build_and_attach_tempfile(filetype, file)
        puts "THE FILETYPE IS #{filetype}"
        convert = {
          'photo' => '.jpg',
          'cv' => '.pdf',
          'cover_letter' => '.docx'
        }
        if file.instance_of?(String)
          # There doesn't seem to be a way to upload a cover_letter file using this API
          convert_html_to_string(file)
        else
          file_path = Rails.root.join('tmp', "#{filetype} - #{@user.first_name} #{@user.last_name} - #{@job.title} - #{@job.company.name}#{convert[filetype]}")
          File.binwrite(file_path, URI.parse(file.url).open.read)
          File.open(file_path)
        end
      end

      def convert_html_to_string(html_string)
        Nokogiri::HTML(html_string).text
      end
    end
  end
end
