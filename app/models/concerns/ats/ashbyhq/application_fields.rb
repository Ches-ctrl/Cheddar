module Ats
  module Ashbyhq
    module ApplicationFields
      def get_application_criteria(job)
        p "Getting AshbyHQ application criteria"
        job.application_criteria = CANDIDATE_FIELDS
        job.save
        # GetFormFieldsJob.perform_later(job.job_posting_url)
      end

      def update_requirements(_job)
        p "Updating job requirements"
      end

      # Organised into sections (sections have labels)
      # May need to do this off of labels rather than locators given form structure

      CANDIDATE_FIELDS = {
        full_name: {
          interaction: :input,
          locators: '_systemfield_name',
          required: true
        },
        pref_name: {
          interaction: :input,
          locators: '_input_1xsmr_28 _input_1dgff_33',
          required: true
        },
        phone_number: {
          interaction: :input,
          locators: 'tel',
          required: true
        },
        email: {
          interaction: :input,
          locators: '_systemfield_email',
          required: true
        },
        resume: {
          interaction: :input,
          locators: '_systemfield_resume',
          required: true
        },
        linkedin: {
          interaction: :input,
          locators: '_input_1xsmr_28 _input_1dgff_33',
          required: true
        }
      }

      LOCATION_FIELDS = {}

      WORKAUTH_FIELDS = {}

      DEGREE_OPTIONS = []

      DISCIPLINE_OPTIONS = []
    end
  end
end
