module Ats
  module Recruitee
    module ApplicationFields
      def get_application_question_set(job, data)
        p "Getting Recruitee application criteria"

        # TODO : implement new application_question_structure structure
        # job.application_question_set = build_application_question_set_from(data)
        job.apply_with_cheddar = true
        job.save
        # TODO: update job.requirement
      end

      def build_application_question_set_from(data)
        attributes = build_core_fields(data)
        additional_fields = build_additional_fields(data['open_questions'])

        return attributes.merge(additional_fields)
      end

      def build_core_fields(data)
        attributes = CORE_FIELDS
        attributes['phone_number'][:required] = data['options_phone'] == 'required'
        attributes['photo'][:required] = data['options_photo'] == 'required'
        attributes['cover_letter'][:required] = data['options_cover_letter'] == 'required'
        attributes['resume'][:required] = data['options_cv'] == 'required'
        attributes
      end

      def build_additional_fields(data)
        additional_fields = {}
        i = 0
        while i < data.size
          if data[i]['kind'] == 'infobox' && i + 1 < data.size # combine infobox with question text
            info = data[i]['body']
            i += 1
          else
            info = nil
          end

          field = data[i]
          kind = field['kind']
          interaction, options = fetch_interaction_and_options(field, FIELD_TYPES[kind])
          question = field['body']
          name = standardize_question(question)
          label = [info, question].reject(&:blank?).join('<br><br>')
          additional_fields.merge!(
            name => {
              interaction:,
              locators: "#{field['id']}:#{CONTENT_CONVERTER[kind]}",
              required: field['required'],
              label:,
              character_length: field.dig('options', 'length'),
              options:
            }.reject { |_, v| v.blank? }
          )

          i += 1
        end
        additional_fields
      end

      def standardize_question(question)
        standardized = question.strip.downcase.gsub(' ', '_').gsub(/[^a-z_]/, '')
        STANDARD_QUESTIONS[standardized] || standardized
      end

      def fetch_interaction_and_options(field, interaction)
        options = field['open_question_options']&.map { |option| option['body'] }
        if interaction == :boolean
          interaction = :select
          options ||= ['Yes', 'No']
        elsif interaction == :agree
          interaction = :select
          options ||= ['I Agree', 'I do not agree']
        end
        [interaction, options]
      end

      CORE_FIELDS = {
        'full_name' => {
          interaction: :input,
          locators: 'name',
          required: true,
          label: 'Full name',
          core_field: true
        },
        'email' => {
          interaction: :input,
          locators: 'email',
          required: true,
          label: 'Email address',
          core_field: true
        },
        'phone_number' => {
          interaction: :input,
          locators: 'phone',
          label: 'Phone number',
          core_field: true
        },
        'photo' => {
          interaction: :upload,
          locators: 'photo',
          label: 'Photo',
          core_field: true
        },
        'cover_letter' => {
          interaction: :upload,
          locators: 'cover_letter',
          label: 'Cover letter',
          core_field: true
        },
        'resume' => {
          interaction: :upload,
          locators: 'cv',
          label: 'CV or resume',
          core_field: true
        }
      }

      FIELD_TYPES = {
        'string' => :input,
        'text' => :input,
        'single_choice' => :select,
        'date' => :date,
        'salary' => :input,
        'number' => :number,
        'multi_choice' => :checkbox,
        'file' => :upload,
        'video' => :upload,
        'boolean' => :boolean,
        'legal' => :agree
      }

      CONTENT_CONVERTER = {
        'string' => 'content',
        'text' => 'content',
        'single_choice' => 'content',
        'date' => 'content',
        'salary' => 'content',
        'number' => 'content',
        'multi_choice' => 'multi_content',
        'file' => 'file',
        'video' => 'file',
        'boolean' => 'flag',
        'legal' => 'flag'
      }

      STANDARD_QUESTIONS = {}
    end
  end
end
