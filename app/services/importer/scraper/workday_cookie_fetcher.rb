# frozen_string_literal: true

module Importer
  module Scraper
    class WorkdayCookieFetcher < ApplicationTask
      include Capybara::DSL

      def initialize(details)
        @create_account_url = details[:create_account_url]
        @sign_in_url = details[:sign_in_url]
        @target = details[:target_url]
        Capybara.configure do |config|
          config.test_id = :'data-automation-id'
          config.default_max_wait_time = 5
        end
        @session = Capybara::Session.new(:selenium) # replace with :selenium_chrome_headless
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
        create_account unless login_success?
        return_cookie
      ensure
        @session.quit
      end

      def cookie_has_updated?
        old_cookie = @cookie
        log_cookie
        @cookie != old_cookie
      end

      def create_account
        click_button('createAccountLink')
        log_cookie
        fill_in('email', with: ENV.fetch('WORKDAY_EMAIL'))
        fill_in('password', with: ENV.fetch('WORKDAY_PASSWORD'))
        fill_in('verifyPassword', with: ENV.fetch('WORKDAY_PASSWORD'))
        check('createAccountCheckbox')
        find_button('createAccountSubmitButton').sibling('div').click
      end

      def log_cookie
        @cookie = page.driver.browser.manage.cookie_named('PLAY_SESSION')
      end

      def login_success? = has_current_path?(@target)

      def return_cookie
        page.document.synchronize do
          raise Capybara::ElementNotFound unless cookie_has_updated?

          page.driver.browser.manage.all_cookies
        end
      end

      def sign_in
        visit @sign_in_url
        log_cookie
        fill_in('email', with: ENV.fetch('WORKDAY_EMAIL'))
        fill_in('password', with: ENV.fetch('WORKDAY_PASSWORD'))
        find_button('signInSubmitButton').sibling('div').click
      end
    end
  end
end
