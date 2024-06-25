module Url
  class CreateCompanyFromUrlJob < ApplicationJob
    queue_as :default
    retry_on StandardError, attempts: 0

    def perform(url)
      Importer::Url::CreateCompanyFromUrl.new(url).create_company
    end
  end
end
