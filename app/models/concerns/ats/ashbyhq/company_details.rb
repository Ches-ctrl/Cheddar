module Ats
  module Ashbyhq
    module CompanyDetails
      private

      def company_details(ats_identifier)
        url_ats_api = "#{url_api}#{ats_identifier}?includeCompensation=true"
        {
          url_ats_api:,
          url_ats_main: "#{url_base}#{ats_identifier}",
          total_live: fetch_total_live(ats_identifier)
        }.merge supplementary_data(ats_identifier)
      end

      def supplementary_data(ats_identifier)
        data = fetch_company_api_data(ats_identifier)
        company_data = data.dig('data', 'organization')
        return {} unless company_data

        {
          name: company_data['name'],
          description: fetch_description(company_data),
          url_website: company_data['publicWebsite'],
          url_careers: company_data['customJobsPageUrl'],
          location: company_data['timezone']
        }
      end

      def fetch_description(data)
        [
          data.dig('theme', 'jobBoardTopDescriptionHtml'),
          data.dig('theme', 'jobBoardBottomDescriptionHtml')
        ].reject(&:blank?).join
      end

      def fetch_company_api_data(ats_identifier)
        url = 'https://jobs.ashbyhq.com/api/non-user-graphql?op=ApiOrganizationFromHostedJobsPageName'
        headers = { 'Content-Type' => 'application/json' }
        body = {
          # TODO: make this query more selective
          query: "query ApiOrganizationFromHostedJobsPageName($organizationHostedJobsPageName: String!) {  organization: organizationFromHostedJobsPageName(    organizationHostedJobsPageName: $organizationHostedJobsPageName  ) {    ...OrganizationParts    __typename  }}fragment OrganizationParts on Organization {  name  publicWebsite  customJobsPageUrl  hostedJobsPageSlug  allowJobPostIndexing  theme {    colors    showJobFilters    showTeams    showAutofillApplicationsBox    logoWordmarkImageUrl    logoSquareImageUrl    applicationSubmittedSuccessMessage    jobBoardTopDescriptionHtml    jobBoardBottomDescriptionHtml    __typename  }  appConfirmationTrackingPixelHtml  recruitingPrivacyPolicyUrl  activeFeatureFlags  timezone  __typename }",
          variables: {
            organizationHostedJobsPageName: ats_identifier
          }
        }.to_json

        response = HTTParty.post(url, headers:, body:)
        JSON.parse(response.body)
      end
    end
  end
end
