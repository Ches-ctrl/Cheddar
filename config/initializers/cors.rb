Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'chrome-extension://hofjpmhpciiodhklobchgedbbglhjboa'
    resource '/api/v0/add_job', headers: :any, methods: [:post]
  end
end
