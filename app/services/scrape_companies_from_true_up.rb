class ScrapeCompaniesFromTrueUp < ApplicationJob
  include Capybara::DSL
  include CompanyCsv
  include AtsRouter
  include HashBuilder
  include ValidUrl

  queue_as :default

  NUMBER_OF_RESULT_PAGES = 70

  def initialize
    @companies = build_ats_companies
    Capybara.current_driver = :selenium_chrome_headless
  end

  def call
    url = "https://www.trueup.io/jobs"

    visit(url)

    companies_added = 0
    begin
      puts "Logging into TrueUp..."
      log_into_website
      sleep 1
      puts "Filtering for tech jobs..."
      page.first('.ais-HierarchicalMenu-link').click
      sleep 1
      puts "Getting as many results as possible (this may take some time)..."
      click_show_more(NUMBER_OF_RESULT_PAGES - 1)

      all('.card-body').each do |job_card|
        @url = job_card.first('div.fw-bold.mb-1 a.text-dark')&.[](:href)
        @alt_id = job_card.first('div.mb-2.align-items-baseline a.text-dark')&.text&.gsub(/[^\w%-]/, '').downcase

        # skip if no ATS indicated
        next unless (ats = ats_system_name&.to_sym)

        # skip if already listed
        next if @companies[ats].include?(@alt_id)

        next unless (company = ats_identifier || alt_identifier)

        companies_added += 1
        @companies[ats] << company
      end
    rescue Capybara::ElementNotFound => e
      puts "Element not found: #{e.message}"
    end

    puts "\nFound #{companies_added} new company ats identifiers."
    puts "\nStoring the information in CSV format..."

    @companies.each do |ats_name, list|
      write_to_csv(ats_name.to_s, list)
    end
  end

  private

  def log_into_website
    click_on 'Log in'
    wait_for_selector = 'username'
    find('#username')

    # Randomly select an email and password from the scrape emails and passwords arrays
    scrape_emails = [ENV['SCRAPE_EMAIL_1'], ENV['SCRAPE_EMAIL_2'], ENV['SCRAPE_EMAIL_3'], ENV['SCRAPE_EMAIL_4']]
    scrape_passwords = [ENV['SCRAPE_PASSWORD_1'], ENV['SCRAPE_PASSWORD_2'], ENV['SCRAPE_PASSWORD_3'], ENV['SCRAPE_PASSWORD_4']]
    random_index = rand(scrape_emails.length)

    fill_in 'username', with: scrape_emails[random_index]
    fill_in 'password', with: scrape_passwords[random_index]
    click_button('Continue')
  end

  def click_show_more(no_of_times)
    no_of_times.times do |i|
      begin
        show_more_button = find('.ais-InfiniteHits-loadMore')
      rescue Capybara::ElementNotFound
        puts "Show more button not found"
        break
      end
      begin
        show_more_button.click
      rescue Selenium::WebDriver::Error::ElementNotInteractableError
        puts "Reached the end of the results after #{i} clicks"
        break
      end
      sleep 1
    end
  end

  def alt_identifier
    return unless ats_system_name == 'greenhouse'

    puts "\ntrying #{@alt_id}..."
    return @alt_id if valid?("https://boards-api.greenhouse.io/v1/boards/#{@alt_id}/")
    puts "it didn't work!"
    return
  end

  def extract_workable_company_from(link)
    # Capybara.current_driver = :selenium_chrome
    # p link
    # begin
    #   link.click
    # rescue ActionController::RoutingError
    #   redirect_url = evaluate_script('window.location.href')
    #   puts "Redirected to: #{redirect_url}"
    # end

    # sleep 6
    # redirect_url = current_url
    # puts "Redirected to: #{redirect_url}"

    # @company = redirect_url.match(/workable\.com\/(.*)\/j/)[1]
    # @workable_companies << @company if @company
  end
end
