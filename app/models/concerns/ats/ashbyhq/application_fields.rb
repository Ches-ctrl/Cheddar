module Ats
  module Ashbyhq
    module ApplicationFields
      def get_application_criteria(job)
        p "Getting AshbyHQ application criteria"
        data = fetch_job_api_data(job.ats_job_id, job.company.ats_identifier)
        return unless (job_data = data.dig('data', 'jobPosting'))

        job.application_criteria = build_application_criteria_from(job_data)
        job.update(deadline: job_data['applicationDeadline']) # not sure what format
        job.save
        # GetFormFieldsJob.perform_later(job.posting_url)
      end

      def fetch_job_api_data(job_id, ats_identifier)
        url = 'https://jobs.ashbyhq.com/api/non-user-graphql?op=ApiJobPosting'
        headers = { 'Content-Type' => 'application/json' }
        body = {
          query: "query ApiJobPosting($organizationHostedJobsPageName: String!, $jobPostingId: String!) {  jobPosting(    organizationHostedJobsPageName: $organizationHostedJobsPageName    jobPostingId: $jobPostingId  ) {    applicationForm {      ...FormRenderParts      __typename    }    surveyForms {      ...FormRenderParts      __typename    }    applicationDeadline    __typename  }}fragment JSONBoxParts on JSONBox {  value  __typename}fragment FileParts on File {  id  filename  __typename}fragment FormFieldEntryParts on FormFieldEntry {  id  field  fieldValue {    ... on JSONBox {      ...JSONBoxParts      __typename    }    ... on File {      ...FileParts      __typename    }    ... on FileList {      files {        ...FileParts        __typename      }      __typename    }    __typename  }  isRequired  descriptionHtml  isHidden  __typename}fragment FormRenderParts on FormRender {  id  formControls {    identifier    title    __typename  }  errorMessages  sections {    fieldEntries {      ...FormFieldEntryParts      __typename    }    isHidden    __typename  }  sourceFormDefinitionId  __typename}",
          variables: {
            jobPostingId: job_id,
            organizationHostedJobsPageName: ats_identifier
          }
        }.to_json

        response = HTTParty.post(url, headers:, body:)
        JSON.parse(response.body)
      end

      def build_application_criteria_from(data)
        attributes = {}

        application_form = data.dig('applicationForm', 'sections')
        data['surveyForms'].each do |survey_form|
          application_form += survey_form['sections']
        end

        application_form.each do |section|
          next if section['isHidden']

          section['fieldEntries'].each do |field|
            attributes.merge! get_attributes(field) unless field['isHidden']
          end
        end

        return attributes
      end

      def get_attributes(field)
        title = field.dig('field', 'title')
        description = field['descriptionHtml']
        name = [title, description].reject(&:blank?).join('<br><br>')

        interaction, options = get_interaction_and_options(field)
        field_attributes = {
          interaction:,
          locators: field.dig('field', 'path'),
          required: field['isRequired'],
          options:
        }.compact
        { name => field_attributes }
      end

      def get_interaction_and_options(field)
        interaction = FIELD_TYPES[field.dig('field', 'type')]
        options = field.dig('field', 'selectableValues')&.map { |option| option['label'] }
        if interaction == :boolean
          options ||= ['Yes', 'No']
          interaction = :select
        end
        [interaction, options]
      end

      def update_requirements(_job)
        p "Updating job requirements"
      end

      # TODO: check the FIELD_TYPES dictionary against what's required for the actual application form

      FIELD_TYPES = {
        'String' => :input,
        'Email' => :input,
        'File' => :upload,
        'Date' => :date,
        'Number' => :number,
        'Boolean' => :boolean,
        'LongText' => :input,
        'ValueSelect' => :select,
        'MultiValueSelect' => :checkbox,
        'Phone' => :input,
        'Score' => :input,
        'SocialLink' => :input
      }

      # TODO: Is the rest of this relevant? Delete if not.

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
