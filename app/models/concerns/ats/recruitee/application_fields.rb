module Ats
  module Recruitee
    module ApplicationFields
      def get_application_criteria(job, data)
        p "Getting Recruitee application criteria"
        job.application_criteria = build_application_criteria_from(data)
        job.save
        # TODO: update job.requirement
      end

      def build_application_criteria_from(data)
        attributes = build_core_fields(data)
        additional_fields = build_additional_fields(data['open_questions'])

        return attributes.merge(additional_fields)
      end

      def build_core_fields(data)
        attributes = CORE_FIELDS
        attributes['phone'][:required] = data['options_phone'] == 'required'
        attributes['photo'][:required] = data['options_photo'] == 'required'
        attributes['cover_letter'][:required] = data['options_cover_letter'] == 'required'
        attributes['resume/cv'][:required] = data['options_cv'] == 'required'
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
              locators: [
                "[open_question_answers_attributes][#{field['position']}][open_question_id]=#{field['id']}",
                "[open_question_answers_attributes][#{field['position']}]#{CONTENT_CONVERTER[kind]}="
              ],
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
          locators: ['candidate[name]'],
          required: true,
          label: 'Full name'
        },
        'email' => {
          interaction: :input,
          locators: ['candidate[email]'],
          required: true,
          label: 'Email address'
        },
        'phone' => {
          interaction: :input,
          locators: ['candidate[phone]'],
          label: 'Phone number'
        },
        'photo' => {
          interaction: :upload,
          locators: ['candidate[photo]'],
          label: 'Photo'
        },
        'cover_letter' => {
          interaction: :upload,
          locators: ['candidate[cover_letter]'],
          label: 'Cover letter'
        },
        'resume/cv' => {
          interaction: :upload,
          locators: ['candidate[cv]'],
          label: 'CV or resume'
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
        'boolean' => :boolean,
        'legal' => :agree
      }

      CONTENT_CONVERTER = {
        'string' => '[content]',
        'text' => '[content]',
        'single_choice' => '[content]',
        'date' => '[content]',
        'salary' => '[content]',
        'number' => '[content]',
        'multi_choice' => '[multi_content][]',
        'file' => '[file]',
        'boolean' => '[flag]',
        'legal' => '[flag]'
      }

      STANDARD_QUESTIONS = {}
    end
  end
end
