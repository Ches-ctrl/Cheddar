source "https://rubygems.org"
# TODO: Add gems to their respective environments
# TODO: Gem versions has to be properly set, this avoids merge conflict in Gemfile.lock

ruby "3.1.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 6.4.2"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Le Wagon Standard Gems
gem "bootstrap"
gem "devise"
gem "autoprefixer-rails"
gem "font-awesome-sass"
gem "simple_form"
gem "sassc-rails"
# Additional Gems installed
gem "ruby-openai"
gem "capybara"
gem "selenium-webdriver", "4.0"
gem "watir"
gem 'sidekiq', '~> 6.5.5'
gem "sidekiq-failures", "~> 1.0"
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'
gem 'rails-html-sanitizer'
gem 'will_paginate', '~> 4.0'

# Additional Gems for API and Scrape features
gem "cloudinary"
gem "pg_search"
gem "nokogiri"
# gem "open-uri"
gem 'csv'
gem 'avo'
gem 'yomu' # this gem is no longer maintained
gem 'tinymce-rails'
gem 'htmltoword'

group :development, :test do
  gem "dotenv-rails"
  gem 'speg' # generate spec files
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "faker"
  gem 'rspec-rails', '~> 6.1.0'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "better_errors"
  gem "binding_of_caller"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  # gem "capybara"
  # gem "selenium-webdriver"
  gem 'factory_bot_rails', '6.4.3'
  gem 'shoulda-matchers', '6.1.0'
end
