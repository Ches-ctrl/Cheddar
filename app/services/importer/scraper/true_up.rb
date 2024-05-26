module Importer
  module Scraper
    class TrueUp
      include Capybara::DSL
      include CompanyCsv
      include CheckUrlIsValid

      # TODO: Refactor this as can be improved and use standard scraping classes

      NUMBER_OF_RESULT_PAGES = 70

      def perform
        configure_settings
        visit(@job_board_url)

        log_into_website
        filter_for_tech_jobs

        click_show_more(NUMBER_OF_RESULT_PAGES - 1)

        scrape_from_job_cards
        store_to_database
      end

      private

      def configure_settings
        @companies = ats_list
        @companies_added = 0
        @job_board_url = "https://www.trueup.io/jobs"
        Capybara.current_driver = :selenium_chrome_headless
        Capybara.configure do |config|
          config.default_max_wait_time = 5
        end
      end

      def log_into_website
        puts "Logging into TrueUp..."
        click_on 'Log in'
        sleep 1

        # Randomly select an email and password from the scrape emails and passwords arrays
        fill_in 'username', with: scrape_emails.sample
        fill_in 'password', with: scrape_passwords.sample
        click_button('Continue')
      end

      def scrape_emails
        (1..4).map do |i|
          ENV.fetch("SCRAPE_EMAIL_#{i}", nil)
        end
      end

      def scrape_passwords
        (1..4).map do |i|
          ENV.fetch("SCRAPE_PASSWORD_#{i}", nil)
        end
      end

      def filter_for_tech_jobs
        puts "Filtering for tech jobs..."
        page.first('.ais-HierarchicalMenu-link').click
        puts "Filtering for London area"
        all(".ais-SearchBox-input").first.set('London')
        all(".ais-SearchBox-submit").first.click
      end

      def click_show_more(no_of_times)
        puts "Getting as many results as possible (this will take a minute or two)..."

        no_of_times.times do |i|
          show_more_button&.click
        rescue Selenium::WebDriver::Error::ElementNotInteractableError
          puts "Reached the end of the results after #{i} clicks"
          break
        end
      end

      def show_more_button
        sleep 1
        return find('.ais-InfiniteHits-loadMore')
      rescue Capybara::ElementNotFound
        puts "Show more button not found"
        return
      end

      def scrape_from_job_cards
        all('.card-body').each do |job_card|
          extract_url(job_card)
          extract_alt_id(job_card)
          # TODO: Fix this given new structure as ParseJobUrlByAts no longer exists
          @ats, @ats_identifier = ParseJobUrlByAts.new(@url).parse(@companies)
          next puts "couldn't parse #{@url}" unless @ats

          @ats_identifier ||= alt_identifier
          next puts "couldn't parse #{@url}" unless @ats && @ats_identifier
          next puts "#{@ats_identifier} already stored!" if already_listed?(@ats_identifier)

          @companies_added += 1
          @companies[@ats.name] << @ats_identifier
        end
      rescue NoMethodError => e
        missing_method = e.message.match(/`(.+?)'/)[1]
        p "Problem with #{@url}: missing a #{missing_method} method#{" for #{@ats.name}" if @ats}!"
      ensure
        Capybara.current_session.driver.quit
      end

      def extract_url(job_card)
        @url = job_card.first('div.fw-bold.mb-1 a.text-dark')&.[](:href)
      end

      def extract_alt_id(job_card)
        @alt_id = job_card.first('div.mb-2.align-items-baseline a.text-dark')&.text&.gsub(/[^\w%-]/, '')&.downcase
      end

      def already_listed?(identifier)
        @companies[@ats.name].include?(identifier)
      end

      def alt_identifier
        return unless @ats.name == 'greenhouse'

        puts "\ntrying #{@alt_id}..."
        return @alt_id if already_listed?(@alt_id) || url_valid?("https://boards-api.greenhouse.io/v1/boards/#{@alt_id}/")

        puts "it didn't work!"
        return
      end

      def store_to_database
        puts "\nFound #{@companies_added} new company ats identifiers."
        puts "\nStoring the information in CSV format..."
        save_ats_list(@companies)
      end
    end
  end
end
