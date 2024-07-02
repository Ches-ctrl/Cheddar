# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-status'

# Adds middleware to Sidekiq to allow for tracking of job status
Sidekiq.configure_client do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
end

Sidekiq.configure_server do |config|
  # accepts :expiration (optional)
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes.to_i

  # accepts :expiration (optional)
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes.to_i
end
