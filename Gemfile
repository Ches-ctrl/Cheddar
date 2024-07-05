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
gem 'psych', "~> 5.1.2" # Extra gem as per Le Wagon setup for Linux laptops

# Middleware
gem 'rack-cors'

# Testing
gem "capybara"
gem "selenium-webdriver", "~> 4.18.1"
# gem "watir" # Do we still need this gem? @Ilya

# Background Processing
gem 'sidekiq', '~> 6.5.5'
gem "sidekiq-failures", "~> 1.0"
gem 'sidekiq-scheduler', '~> 5.0', '>= 5.0.3'
gem 'sidekiq-status'
# gem 'sidekiq-cron' # Add to be able to schedule jobs at specific times

# Storage
gem "cloudinary"
gem 'aws-sdk-s3', '~> 1'

# Admin
gem 'avo'

# AI
gem "ruby-openai"

# SEO
gem 'meta-tags'
# gem 'sitemap_generator' # TODO: install this gem for sitemap generation

# Email & CRM
gem 'hubspot-api-client'
gem 'sendgrid-ruby'

# Feature Flags
gem "flipper-active_record", "~> 1.3"

# CSV
gem 'csv'

# Parsing
gem "nokogiri"
gem 'rails-html-sanitizer'

# HTTP Clients
# gem 'httparty' # Installed as a dependency via Avo
# gem 'faraday' # Installed as a dependency via Cloudinary

# Web Scraping Frameworks
# gem 'spidr' # TODO: Install for CompanyCrawler and NetZeroChecker
# gem 'tanakai' # potentially install this gem if spidr proves insufficient, based on capybara
# gem 'wombat' # backup gem for web scraping based on mechanize

# Monitoring
gem 'newrelic_rpm'

# Analytics
# gem 'analytics-ruby', '~> 2.4.0', :require => 'segment/analytics' # TODO: install this gem for analytics

# Logs
# gem 'logstasher' # ? Install? Free but may be complicated. Check on Heroku

# Notifications
# gem 'noticed' # TODO: install this gem for notifications

# Error Tracking
# gem 'sentry-raven' # TODO: install this gem for error tracking

# Pagination
# gem 'pagy' # installed via Avo
gem 'kaminari' # TODO: check whether we can replace with pagy

# Front-end
# gem "high_voltage", "~> 3.1" # Turned off at the moment
gem 'tinymce-rails' # TODO: now have trix and action text (check whether we need to replace)

# Search
gem "pg_search"
# gem "algoliasearch-rails" # TODO replace pg_search with algolia once schema is stable

# Location
gem 'geocoder'

# Cover Letters
gem 'yomu' # this gem is no longer maintained - used for custom cover letters # TODO: remove
# gem 'henkei' # alternative maintained gem to yomu for cover letters # TODO: install
gem 'htmltoword'

# Production
# gem "puma_worker_killer" # NB. Doesn't actually solve memory problems!

group :development, :test do
  gem "dotenv-rails"
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
  gem "faker"
  gem 'rspec-rails', '~> 6.1.0'
  # gem 'rspec-benchmark' # Additional gem for benchmarking tests
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'ruby-prof'
  # gem 'parallel_tests' # TODO: install this gem for parallel testing

  # Security
  gem 'brakeman', require: false

  # Email
  # gem 'letter_opener' # TODO: install this gem for email testing
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem 'bullet'
  gem "better_errors"
  gem "binding_of_caller"

  # Performance
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "rack-mini-profiler"
  # gem 'memory_profiler' # Additional gem for memory profiling
  gem 'derailed_benchmarks'
  gem 'stackprof'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # gem "error_highlight", ">= 0.6.0", platforms: [:ruby]

  gem "rails_best_practices"

  # ERD Generation
  gem 'rails-erd'
end

group :test do
  gem 'factory_bot_rails', '6.4.3'
  gem 'shoulda-matchers', '6.1.0'

  # API Calls
  gem 'vcr'
  gem 'webmock'
end

gem "tailwindcss-rails", "~> 2.6"
