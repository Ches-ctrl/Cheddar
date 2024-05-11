source "https://rubygems.org"

ruby "3.1.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails', '~> 3.4', '>= 3.4.2'

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
# gem "jbuilder"
gem 'json', '~> 2.6', '>= 2.6.3'

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Le Wagon Standard Gems
gem "devise"
gem "bootstrap"
gem "autoprefixer-rails"
gem "sassc-rails"
gem "font-awesome-sass", "~> 6.5.1"
gem "simple_form"
gem 'psych', "~> 4.0" # Extra gem as per Le Wagon setup for Linux laptops

# Middleware
gem 'rack-cors'

# Testing
gem "capybara"
gem "selenium-webdriver", "~> 4.18.1"
gem "watir" # Do we still need this gem? @Ilya

# Background Processing
gem 'sidekiq', '~> 6.5.5'
gem "sidekiq-failures", "~> 1.0"
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'

# Storage
gem "cloudinary"

# Admin
gem 'avo'

# AI
gem "ruby-openai"

# SEO
gem 'meta-tags'
# gem 'sitemap_generator' # TODO: install this gem for sitemap generation

# Email
# gem 'sendgrid-ruby' # TODO: install this gem for sending emails

# Importing, Parsing & APIs
gem 'csv' # can probably use ruby standard library
gem "nokogiri"
gem 'faraday' # TODO: use this gem for API calls (not currently in action)
gem 'rails-html-sanitizer'
gem "flipper-active_record", "~> 1.3"

# Monitoring
# gem 'newrelic_rpm' # TODO: install this gem for monitoring

# Analytics
# gem 'analytics-ruby', '~> 2.4.0', :require => 'segment/analytics' # TODO: install this gem for analytics

# Logs
# gem 'logstasher' # ? Install? Free but may be complicated. Check on Heroku

# Notifications
# gem 'noticed' # TODO: install this gem for notifications

# Error Tracking
# gem 'sentry-raven' # TODO: install this gem for error tracking

# Front-end
gem 'will_paginate', '~> 4.0' # TODO: Update to kaminari now index page is fixed (better maintained / looks nicer)
# gem 'kaminari'
gem "high_voltage", "~> 3.1"
gem 'tinymce-rails' # TODO: now have trix and action text (check whether we need to replace)

# Features
gem "pg_search"
gem 'geocoder'
gem 'yomu' # this gem is no longer maintained - used for custom cover letters
gem 'htmltoword' # TODO: Check if we use this anywhere

group :development, :test do
  gem "dotenv-rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "faker"
  gem 'rspec-rails', '~> 6.1.0'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'

  # Email
  # gem 'letter_opener' # TODO: install this gem for email testing
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'bullet'
  gem "better_errors"
  gem "binding_of_caller"

  # Security
  # gem 'brakeman', require: false # TODO: install this gem for security checks

  # Performance
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler" # TODO: install this gem for performance monitoring
  # gem 'memory_profiler' # Additional gem for memory profiling
  # gem 'stackprof' # Additional gem for call-stack profiling flamegraphs

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # gem "error_highlight", ">= 0.6.0", platforms: [:ruby]
end

group :test do
  gem 'factory_bot_rails', '6.4.3'
  gem 'shoulda-matchers', '6.1.0'

  # API Calls
  gem 'vcr'
  gem 'webmock'
end
