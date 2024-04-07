module Ats
  module Recruitee
    module ApplicationFields
      def get_application_criteria(job)
        p "Getting Recruitee application criteria"
        job.application_criteria = CORE_FIELDS
        job.save
        # GetFormFieldsJob.perform_later(job.job_posting_url)
      end

      CORE_FIELDS = {
        resume: {
          interaction: :upload,
          locators: 'candidate[cv]',
          required: true
        },
        full_name: {
          interaction: :input,
          locators: 'candidate[name]',
          required: true
        },
        email: {
          interaction: :input,
          locators: 'candidate[email]',
          required: true
        },
        phone: {
          interaction: :input,
          locators: 'PhoneInputInput',
          required: true
        },
        profile_photo: {
          interaction: :input,
          locators: 'candidate[photo]',
          required: false
        },
        cover_letter: {
          interaction: :upload,
          locators: 'candidate[coverLetterFile]',
          required: true
        },
        where_home: {
          interaction: :input,
          locators: 'candidate[openQuestionAnswers][0][content]',
          required: true
        },
        when_start: {
          interaction: :input,
          locators: 'candidate[openQuestionAnswers][1][content]',
          required: true
        },
        visa_sponsorship: {
          interaction: :select,
          locators: 'candidate[openQuestionAnswers][2][flag]',
          required: true
        },
        hear_about_company: {
          interaction: :checkbox,
          locators: 'candidate[openQuestionAnswers][3][multiContent][]',
          required: false
        }
      }
    end
  end
end
