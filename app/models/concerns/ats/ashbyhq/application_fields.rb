module Ats
  module Ashbyhq
    module ApplicationFields
      include FaradayHelpers

      def get_application_question_set(job, _data)
        p "Getting AshbyHQ application criteria"
        data = fetch_job_api_data(job.ats_job_id, job.company.ats_identifier)
        return [] unless (job_data = data&.dig('data', 'jobPosting'))

        job.update(deadline: job_data['applicationDeadline']) # not sure what format
        Importer::GetAshbyFields.call(job, job_data)
      end

      private

      def fetch_job_api_data(job_id, ats_identifier)
        faraday_request request_details(job_id, ats_identifier)
      end

      def endpoint = 'https://jobs.ashbyhq.com/api/non-user-graphql?op=ApiJobPosting'

      def query = "query ApiJobPosting($organizationHostedJobsPageName: String!, $jobPostingId: String!) {  jobPosting(    organizationHostedJobsPageName: $organizationHostedJobsPageName    jobPostingId: $jobPostingId  ) {    applicationForm {      ...FormRenderParts      __typename    }    surveyForms {      ...FormRenderParts      __typename    }    applicationDeadline    applicationLimitCalloutHtml    __typename  }}fragment JSONBoxParts on JSONBox {  value  __typename}fragment FileParts on File {  id  filename  __typename}fragment FormFieldEntryParts on FormFieldEntry {  id  field  fieldValue {    ... on JSONBox {      ...JSONBoxParts      __typename    }    ... on File {      ...FileParts      __typename    }    ... on FileList {      files {        ...FileParts        __typename      }      __typename    }    __typename  }  isRequired  descriptionHtml  isHidden  __typename}fragment FormRenderParts on FormRender {  id  formControls {    identifier    title    __typename  }  errorMessages  sections {    title    descriptionHtml    fieldEntries {      ...FormFieldEntryParts      __typename    }    isHidden    __typename  }  sourceFormDefinitionId  __typename}"

      def request_details(job_id, ats_identifier)
        {
          endpoint:,
          verb: :post,
          options: {
            headers: { 'Content-Type' => 'application/json' },
            body: {
              query:,
              variables: {
                jobPostingId: job_id,
                organizationHostedJobsPageName: ats_identifier
              }
            }.to_json
          }
        }
      end
    end
  end
end
