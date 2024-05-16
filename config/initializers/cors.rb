Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['CHROME_EXTENSION_ORIGIN']
    resource '/api/v0/add_job', headers: :any, methods: [:post]
  end
end
