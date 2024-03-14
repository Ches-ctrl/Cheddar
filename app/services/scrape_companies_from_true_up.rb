class ScrapeCompaniesFromTrueUp < ApplicationJob
  include Capybara::DSL
  include CompanyCsv
  include AtsRouter
  include Ats::Greenhouse::FetchCompanyJobs

  queue_as :default

  NUMBER_OF_RESULT_PAGES = 4

  def initialize
    @greenhouse_companies = load_from_csv('greenhouse')
    @lever_companies = load_from_csv('lever')
    @workable_companies = Set.new
    Capybara.current_driver = :selenium_chrome_headless
  end

  def call
    url = "https://www.trueup.io/jobs"

    visit(url)

    begin
      log_into_website
      sleep 1
      page.first('.ais-HierarchicalMenu-link').click
      sleep 1
      click_show_more(NUMBER_OF_RESULT_PAGES - 1)

      job_cards = all('.card-body')

      job_cards.each do |job_card|
        @url = job_card.first('div.fw-bold.mb-1 a.text-dark')&.[](:href)
        p "Job URL: #{@url}"

        job_title = job_card.first('div.fw-bold.mb-1 a.text-dark')&.text&.strip
        job_company = job_card.first('div.mb-2.align-items-baseline a.text-dark')&.text&.strip

        puts "Scraping #{job_title} with #{job_company}..."

        @company = false

        if @url.include?('greenhouse') || @url.include?('gh_jid')
          extract_greenhouse_company
        elsif @url.include?('lever')
          extract_lever_company
        elsif @url.include?('workable')
          extract_workable_company_from(job_card.first('div.fw-bold.mb-1 a.text-dark'))
        end

      end
    rescue Capybara::ElementNotFound => e
      puts "Element not found: #{e.message}"
    end

    puts "\nStoring the information in CSV format..."
    write_to_csv('greenhouse', @greenhouse_companies)
    write_to_csv('lever', @lever_companies)
    # write_to_csv('workable', @workable_companies)

    puts "\nWorkable companies:"
    @workable_companies.each do |company|
      puts company
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
    no_of_times.times do
      begin
        show_more_button = find('.ais-InfiniteHits-loadMore')
      rescue Capybara::ElementNotFound
        puts "Show more button not found"
        break
      end
      show_more_button.click
      sleep 1
    end
  end

  def extract_greenhouse_company
    regex_options = [
      Regexp.new('greenhouse\.io\/(.*)\/jobs'),
      Regexp.new('greenhouse\.io\/embed\/job_app\?for=([a-z0-9]*)'),
      Regexp.new(':\/\/(?:www\.|careers\.)?([^.]*)')
    ]
    regex_options.size.times do |i|
      match_data = @url.match(regex_options[i])
      if match_data
        @company = match_data[1]
        if i.positive?
          p "testing company_ats_identifier for #{@company}..."
          unless fetch_company_jobs(@company)
            @company = nil
            puts "This one was no good: #{company}"
          end
        end
        break
      end
    end
    @greenhouse_companies << @company if @company
  end

  def extract_lever_company
    @company = @url.match(/jobs\.lever\.co\/(.*)\//)[1]
    @lever_companies << @company if @company
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
