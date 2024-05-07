module Ats
  module Recruitee
    module ApplicationFields
      def get_application_criteria(job, data)
        p "Getting Recruitee application criteria"
        job.application_criteria = build_application_criteria_from(data)
        job.save
        # GetFormFieldsJob.perform_later(job.posting_url)
      end

      def build_application_criteria_from(data)
        attributes = build_core_fields(data)
        additional_fields = build_additional_fields(data['open_questions'])

        return attributes.merge(additional_fields)
      end

      def build_core_fields(data)
        attributes = CORE_FIELDS
        attributes['Phone number'][:required] = data['options_phone'] == 'required'
        attributes['Photo'][:required] = data['options_photo'] == 'required'
        attributes['Cover letter'][:required] = data['options_cover_letter'] == 'required'
        attributes['CV or resume'][:required] = data['options_cv'] == 'required'
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
          question = [info, field['body']].reject(&:blank?).join('<br><br>')
          additional_fields.merge!(
            question => {
              interaction: :input,
              locators: [
                "[open_question_answers_attributes][#{field['position']}][open_question_id]=#{field['id']}",
                "[open_question_answers_attributes][#{field['position']}]#{CONTENT_CONVERTER[field['kind']]}="
              ],
              required: field['required'],
              kind: field['kind'],
              character_length: field.dig('options', 'length'),
              options: field['open_question_options'].map { |option| option['body'] }
            }.reject { |_, v| v.blank? }
          )

          i += 1
        end
        additional_fields
      end

      CORE_FIELDS = {
        'Full name' => {
          interaction: :input,
          locators: ['candidate[name]'],
          required: true
        },
        'Email address' => {
          interaction: :input,
          locators: ['candidate[email]'],
          required: true
        },
        'Phone number' => {
          interaction: :input,
          locators: ['candidate[phone]']
        },
        'Photo' => {
          interaction: :upload,
          locators: ['candidate[photo]']
        },
        'Cover letter' => {
          interaction: :upload,
          locators: ['candidate[cover_letter]']
        },
        'CV or resume' => {
          interaction: :upload,
          locators: ['candidate[cv]']
        }
      }

      CONTENT_CONVERTER = {
        'string' => '[content]',
        'text' => '[content]',
        'single_choice' => '[content]',
        'data' => '[content]',
        'salary' => '[content]',
        'number' => '[content]',
        'multi_choice' => '[multi_content][]',
        'file' => '[file]',
        'boolean' => '[flag]',
        'legal' => '[flag]'
      }
    end
  end
end
