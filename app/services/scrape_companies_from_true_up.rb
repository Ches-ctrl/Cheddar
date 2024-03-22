class ScrapeCompaniesFromTrueUp < ApplicationJob
  include Capybara::DSL
  include CompanyCsv
  include HashBuilder
  include ValidUrl

  NUMBER_OF_RESULT_PAGES = 70

  def initialize
    @companies = ats_list
    @companies_added = 0
    @job_board_url = "https://www.trueup.io/jobs"
    Capybara.current_driver = :selenium_chrome_headless
  end

  def call
    visit(@job_board_url)

    log_into_website
    filter_for_tech_jobs

    click_show_more(NUMBER_OF_RESULT_PAGES - 1)

    scrape_from_job_cards
    store_to_database
  end

  private

  def log_into_website
    puts "Logging into TrueUp..."
    click_on 'Log in'

    # Randomly select an email and password from the scrape emails and passwords arrays
    fill_in 'username', with: scrape_emails.sample
    fill_in 'password', with: scrape_passwords.sample
    click_button('Continue')
    sleep 1
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
    sleep 1
    puts "Filtering for London area"
    all(".ais-SearchBox-input").first.set('London')
    all(".ais-SearchBox-submit").first.click
    sleep 1
  end

  def click_show_more(no_of_times)
    puts "Getting as many results as possible (this may take some time)..."

    no_of_times.times do |i|
      begin
        show_more_button&.click
      rescue Selenium::WebDriver::Error::ElementNotInteractableError
        puts "Reached the end of the results after #{i} clicks"
        break
      end
      sleep 1
    end
  end

  def show_more_button
    return find('.ais-InfiniteHits-loadMore')
  rescue Capybara::ElementNotFound
    puts "Show more button not found"
    return
  end

  def scrape_from_job_cards
    all('.card-body').each do |job_card|
      extract_url(job_card)
      extract_alt_id(job_card)

      next unless (@ats, @ats_identifier = JobUrl.new(@url).parse)
      next puts "couldn't parse #{@url}" unless @ats_identifier || alt_identifier
      next if already_listed?

      @companies_added += 1
      @companies[@ats.name] << @ats_identifier
    end
  end

  def extract_url(job_card)
    @url = job_card.first('div.fw-bold.mb-1 a.text-dark')&.[](:href)
  end

  def extract_alt_id(job_card)
    @alt_id = job_card.first('div.mb-2.align-items-baseline a.text-dark')&.text&.gsub(/[^\w%-]/, '')&.downcase
  end

  def already_listed?
    @companies[@ats.name].include?(@ats_identifier)
  end

  def alt_identifier
    return unless @ats.name == 'greenhouse'

    puts "\ntrying #{@alt_id}..."
    return @ats_identifer = @alt_id if valid?("https://boards-api.greenhouse.io/v1/boards/#{@alt_id}/")

    puts "it didn't work!"
    return
  end

  def store_to_database
    puts "\nFound #{@companies_added} new company ats identifiers."
    puts "\nStoring the information in CSV format..."
    save_ats_list
    # @companies.each do |ats_name, list|
    #   write_to_csv(ats_name.to_s, list)
    # end
  end
end
