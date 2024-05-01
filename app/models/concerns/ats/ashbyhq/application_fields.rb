module Ats
  module Ashbyhq
    module ApplicationFields
      def get_application_criteria(job)
        p "Getting AshbyHQ application criteria"
        data = fetch_api_data(job.ats_job_id, job.company.ats_identifier)
        return unless (job_data = data.dig('data', 'jobPosting'))

        job.application_criteria = build_application_criteria_from(job_data)
        job.save
        # GetFormFieldsJob.perform_later(job.posting_url)
      end

      def fetch_api_data(job_id, ats_identifier)
        url = 'https://jobs.ashbyhq.com/api/non-user-graphql?op=ApiJobPosting'
        headers = { 'Content-Type' => 'application/json' }
        body = {
          query: "query ApiJobPosting($organizationHostedJobsPageName: String!, $jobPostingId: String!) {  jobPosting(    organizationHostedJobsPageName: $organizationHostedJobsPageName    jobPostingId: $jobPostingId  ) {    id    title    departmentName    locationName    employmentType    descriptionHtml    isListed    isConfidential    teamNames    applicationForm {      ...FormRenderParts      __typename    }    surveyForms {      ...FormRenderParts      __typename    }    secondaryLocationNames    compensationTierSummary    compensationTiers {      id      title      tierSummary      __typename    }    applicationDeadline    compensationTierGuideUrl    scrapeableCompensationSalarySummary    compensationPhilosophyHtml    applicationLimitCalloutHtml    shouldAskForTextingConsent    candidateTextingPrivacyPolicyUrl    __typename  }}fragment JSONBoxParts on JSONBox {  value  __typename}fragment FileParts on File {  id  filename  __typename}fragment FormFieldEntryParts on FormFieldEntry {  id  field  fieldValue {    ... on JSONBox {      ...JSONBoxParts      __typename    }    ... on File {      ...FileParts      __typename    }    ... on FileList {      files {        ...FileParts        __typename      }      __typename    }    __typename  }  isRequired  descriptionHtml  isHidden  __typename}fragment FormRenderParts on FormRender {  id  formControls {    identifier    title    __typename  }  errorMessages  sections {    title    descriptionHtml    fieldEntries {      ...FormFieldEntryParts      __typename    }    isHidden    __typename  }  sourceFormDefinitionId  __typename}",
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
        application_form.each do |section|
          next if section['isHidden']

          section['fieldEntries'].each do |question|
            next if question['isHidden']

            attributes.merge! get_attributes(question)
          end
        end
        survey_forms = data['surveyForms']
        survey_forms.each do |survey_form|
          survey_form['sections'].each do |section|
            section['fieldEntries'].each do |question|
              next if question['isHidden']

              attributes.merge! get_attributes(question)
            end
          end
        end
        return attributes
      end

      def get_attributes(question)
        title = question.dig('field', 'title')
        description = question['descriptionHtml']
        name = [title, description].reject(&:blank?).join('<br>')

        interaction = INTERACTIONS[question.dig('field', 'type')]
        { name => {
                    interaction:,
                    locators: question['path'],
                    required: question['isRequired'],
                    options: question.dig('field', 'selectableValues')&.map { |option| option['label'] }
                  } }
      end

      def update_requirements(_job)
        p "Updating job requirements"
      end

      # Organised into sections (sections have labels)
      # May need to do this off of labels rather than locators given form structure

      INTERACTIONS = {
        'String' => :input,
        'Email' => :input,
        'File' => :upload,
        'Boolean' => :checkbox,
        'LongText' => :input,
        'ValueSelect' => :checkbox,
        'MultiValueSelect' => :select
      }

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
