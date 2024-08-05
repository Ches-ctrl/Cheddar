# frozen_string_literal: true

module Importer
  module Scraper
    class WorkdayCookieFetcher < ApplicationTask
      include Capybara::DSL

      def initialize(details)
        @sign_in_url = details[:sign_in_url]
        @create_account_url = details[:create_account_url]
        Capybara.configure do |config|
          config.test_id = :'data-automation-id'
          config.default_max_wait_time = 5
        end
        @session = Capybara::Session.new(:selenium)
      end

      def call
        return nil unless processable

        using_session(@session) do
          process
        end
      end

      private

      def processable
        @sign_in_url && @create_account_url
      end

      def process
        sign_in
        return_cookie
      ensure
        @session.quit
      end

      def return_cookie
        page.driver.browser.manage.all_cookies
      end

      def sign_in
        visit @sign_in_url
        fill_in('email', with: ENV.fetch('WORKDAY_EMAIL'))
        fill_in('password', with: ENV.fetch('WORKDAY_PASSWORD'))
        find_button('signInSubmitButton').sibling('div').click
      end
    end
  end
end
