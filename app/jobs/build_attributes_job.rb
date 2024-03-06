require 'nokogiri'

# This file is specific to Greenhouse

class BuildAttributesJob < ApplicationJob
  include Capybara::DSL

  queue_as :default
  sidekiq_options retry: false

  # TODO: Generalise to all supported ATS systems
  # TODO: Calculate total number of input fields and implied difficulty of application
  # TODO: Potentially change to scraping all fields from the job posting
  # TODO: Add boolean cv required based on this scrape
  # TODO: add test of filling out the form fields before job goes live

  def perform(url)
    Capybara.current_driver = :selenium_chrome_headless

    visit(url)
    return if page.has_selector?('#flash_pending')

    job = Job.find_by(job_posting_url: url)

    form = find('form', text: /apply|application/i)
    form_html = page.evaluate_script("arguments[0].outerHTML", form.native)
    nokogiri_description = Nokogiri::HTML.fragment(description_html)
  end
end
