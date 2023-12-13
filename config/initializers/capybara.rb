require 'capybara/rails'
require 'capybara/dsl'

Capybara.run_server = false

Capybara.register_driver :selenium do |app|
  if Rails.env.production?
    chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)
    chrome_opts = chrome_bin ? { "binary" => chrome_bin } : {}
    Selenium::WebDriver::Chrome.path = chrome_bin if chrome_bin
    Capybara::Selenium::Driver.new(
      app,
      browser: :chrome,
      options: Selenium::WebDriver::Options.chrome
    )
  else
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument("--headless")
    # options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    options.add_argument("--window-size=1400,1000")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--remote-debugging-port=9225")
    Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
  end
end

Capybara.ignore_hidden_elements = false
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
