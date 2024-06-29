Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV.fetch('CHROME_EXTENSION_ORIGIN', 'DEFAULT_API_KEY_FOR_DEV')
    resource '/api/v0/add_job', headers: :any, methods: [:post]
  end
end
