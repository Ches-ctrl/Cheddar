class ScrapeJobBnJob < ApplicationJob
  queue_as :default

  def perform
    Capybara.default_max_wait_time = 10

    url = [ENV['SCRAPE_URL_1'], ENV['SCRAPE_URL_2'], ENV['SCRAPE_URL_3'], ENV['SCRAPE_URL_4'], ENV['SCRAPE_URL_5'], ENV['SCRAPE_URL_6']]
    search_criteria = ['London Developer', 'London Full Stack', 'London Product Management', 'London Data Science', 'London Data Engineering', 'London Design']

    # Add this as a command to the admin panel, with details as to when the job was last run and current DB stats:
    p "URL Options: #{url}"
    p "Search Criteria Options: #{search_criteria}"
    p "Which URL and search criteria would you like to scrape?"

    url.each_with_index do |u, index|
      p "#{index + 1}. #{u} - #{search_criteria[index]}"
    end

    user_input = gets.chomp.to_i

    if user_input.between?(1, url.length)
      url = url[user_input - 1]
      search_criteria = search_criteria[user_input - 1]
    else
      puts "Invalid input. Please try again."
      return
    end

    visit(url)

    begin
      # Login and fill in search criteria
      log_into_website
      # fill_in '.ais-SearchBox-input', with: search_criteria
      sleep 1 # Wait for the search to be conducted
      click_show_more(times: 3)

      job_cards = all('.card-body')

      job_cards.each do |job_card|
        job_url = job_card.first('div.fw-bold.mb-1 a.text-dark')&.[](:href)
        p "Job URL: #{job_url}"

        job_url = job_url.split('?').first if job_url.include?('?')
        p "Job URL: #{job_url}"

        job_url = job_url.chomp('apply/') if job_url.end_with?('/apply/')
        p "Job URL: #{job_url}"

        job_title = job_card.first('div.fw-bold.mb-1 a.text-dark')&.text&.strip
        p "Job Title: #{job_title}"

        # TODO: First check if company (with alternative spellings) already exists in the database)

        company_attributes = {
          company_name: job_card.first('div.mb-2.align-items-baseline a.text-dark')&.text&.strip,
          location: job_card.first("div.text-secondary[style='width: 100%; font-size: 12px; font-weight: 500;']")&.text&.strip,
          industry: "Tech"
        }
        p company_attributes

        company = Company.find_or_create_by(company_name: company_attributes[:company_name])
        p "Find or create by complete: "

        company.update(company_attributes)
        p company

        if company.save
          puts "New company created: #{company.company_name}"
          job = Job.find_or_create_by(job_posting_url: job_url, job_title: job_title, company_id: company.id)
          if job.new_record?
            job.update(job_posting_url: job_url, job_title: job_title, company: company)

            # Pseudocode:
            # Go to job page and work out its details (e.g. salary, job description, etc.)
            # Save these to the job instance. Save this as is and queue a background job to query the job application form fields later
            # Then use the scraper to find out which fields are required for the job application
            # Do so by calling the ai_find_form_fields method and iterating through the potential ATS formats (order by frequency)
            # If one of these works, then save the ATS format to the job instance
            # If none of these work, then ask the AI to work out what the ATS format is and save this as a new instance of ATS format
            # Then save the job application criteria
            # Then save the job instance

            # TODO: Implement the above logic
            # TODO: Create a new find job details job

            if job.save
              puts "Created job: #{job_title} at #{company.company_name}"
            else
              puts "Failed to create job: #{job.errors.full_messages.join(", ")}"
            end
          else
            puts "Job already exists: #{job_title} at #{company.company_name}"
          end
        else
          puts "Failed to create new company"
        end

      end

    rescue Capybara::ElementNotFound => e
      puts "Element not found: #{e.message}"
    end
  end

  private

  def log_into_website
    click_on 'Log in'
    wait_for_selector = 'username'
    find('#username')

    # TODO: Add 4x scrape emails and passwords
    # Randomly select an email and password from the scrape emails and passwords arrays
    scrape_emails = [ENV['SCRAPE_EMAIL_1'], ENV['SCRAPE_EMAIL_2'], ENV['SCRAPE_EMAIL_3'], ENV['SCRAPE_EMAIL_4']]
    scrape_passwords = [ENV['SCRAPE_PASSWORD_1'], ENV['SCRAPE_PASSWORD_2'], ENV['SCRAPE_PASSWORD_3'], ENV['SCRAPE_PASSWORD_4']]
    random_index = rand(scrape_emails.length)

    fill_in 'username', with: scrape_emails[random_index]
    fill_in 'password', with: scrape_passwords[random_index]
    # click_button('Continue')
    click_button('Continue', class: ['c1939bbc3'])


    # find_button('Continue', type: "submit").click
    # , class: ['c1939bbc3']
    # cb8dcbc41 c5fa977b5 c3419c4cf cf576c2dc cdb91ebae
    # <button type="submit" name="action" value="default" class="c1939bbc3 cc78b8bf3 ce1155df5 c1d2ca6e3 c331afe93" data-action-button-primary="true">Continue</button>

 end

  def click_show_more(times: 3)
    times.times do
      begin
        show_more_button = find('.ais-InfiniteHits-loadMore')
        show_more_button.click

        # Optional: Wait for the next set of results to load
        # sleep 1

      rescue Capybara::ElementNotFound
        puts "Show more button not found"
        break # Exit the loop if the button is not found
      end
    end
  end

  def wait_for_selector
    # Wait for the search results to load; use a selector that identifies the loading of search results
    # wait_for_selector = 'ais-SearchBox-reset'
    # find(wait_for_selector)
  end

  def scroll_to_element
    # TODO: Update scroll_to_element to scroll to the element as currently doesn't work with multiple card-body elements
    # element_to_scroll_to = find('.card-body').first
    # p "Scrolling to element: #{element_to_scroll_to}"
    # scroll_to(element_to_scroll_to)
    # element_to_scroll_to.click
  end
end
