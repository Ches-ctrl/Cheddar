module Ats
  module Manatal
    module ApplicationFields
      def get_application_question_set(job, _data)
        p "Getting Manatal application criteria"
        data = fetch_application_fields(job)

        job.application_question_set = build_application_question_set_from(data)
        job.apply_with_cheddar = true
        job.save
        # TODO: update job.requirement
      end

      def fetch_application_fields(job)
        endpoint = "#{job.api_url}application-form/"
        get_json_data(endpoint)
      end

      def build_application_question_set_from(data)
        data.to_h do |field|
          p field
          label = field['label']
          if CORE_FIELDS.include?(label)
            attributes = CORE_FIELDS[label]
            name = attributes[:id]
            interaction = attributes[:interaction]
            options = nil
            core_field = true
          else
            name = field['slug']
            interaction, options = fetch_interaction_and_options(name, field['type'])
            core_field = false
          end
          [
            name, {
              interaction:,
              locators: field['slug'].blank? ? label.downcase : field['slug'],
              required: field['is_required'],
              label:,
              options:,
              core_field:
            }.compact
          ]
        end
      end

      def fetch_nationalities
        endpoint = "#{API_BASE_URL}nationalities/"
        data = get_json_data(endpoint)

        data.map do |nationality|
          "#{nationality['demonym']} (#{nationality['common_name']})"
        end
      end

      def fetch_languages
        endpoint = "#{API_BASE_URL}languages/"
        data = get_json_data(endpoint)

        data.map do |language|
          language['name']
        end
      end

      def fetch_interaction_and_options(id, field_type)
        if field_type == 'boolean'
          interaction = :select
          options = ['Yes', 'No']
        elsif id == 'nationalities'
          interaction = :checkbox
          options = fetch_nationalities
        elsif id == 'languages'
          interaction = :checkbox
          options = fetch_languages
        end
        interaction ||= FIELD_TYPES[field_type]
        options ||= nil
        [interaction, options]
      end

      API_BASE_URL = 'https://core.api.manatal.com/open/v3/'
      FIELD_TYPES = {
        'char' => :input,
        'longtext' => :input,
        'boolean' => :boolean,
        'integer' => :number
      }
      CORE_FIELDS = {
        'Full Name' => {
          interaction: :input,
          id: 'full_name'
        },
        'Email' => {
          interaction: :input,
          id: 'email'
        },
        'Phone' => {
          interaction: :input,
          id: 'phone_number'
        },
        'Linkedin' => {
          interaction: :input,
          id: 'linkedin_url'
        },
        'Resume' => {
          interaction: :upload,
          id: 'resume'
        }
      }
    end
  end
end
