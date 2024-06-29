Rails.application.routes.draw do
  require "sidekiq/web"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable" # TODO: fix as not found at the moment
  mount Avo::Engine, at: '/avo'

  devise_for :users, except: [:fetch_template], controllers: { registrations: 'users/registrations' }
  post '/users/fetch_template', to: 'users#fetch_template', as: :fetch_template
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  get "up" => "rails/health#show", as: :rails_health_check

  # API
  namespace :api do
    namespace :v0 do
      post 'add_job', to: 'jobs#add_job'
    end
  end

  # Pages
  root to: 'uncategorized_pages#tothemoon'
  get '/about', to: 'uncategorized_pages#about'
  get '/contact', to: 'uncategorized_pages#contact'
  get '/privacy', to: 'uncategorized_pages#privacy'
  get '/terms', to: 'uncategorized_pages#terms'

  # Jobs
  get '/jobs/add_job', to: 'jobs#add_job'

  # Chatbot
  post '/chatbot/chat', to: 'messages#chat'

  # Resources
  resources :companies, only: %i[index show]
  resources :emails, only: [:create]
  resources :educations, only: %i[new create]

  # Jobs
  resources :opportunities, path: '/jobs', only: %i[index show] do
    resources :saved_jobs, only: %i[create]
    delete '/saved_jobs', to: 'saved_jobs#destroy', as: :destroy_saved_jobs
    collection do
      get 'opportunity_autocomplete', to: 'opportunity_autocomplete#index'
    end
  end

  get 'basket', to: 'saved_jobs#index', as: :saved_jobs
  get 'in_progress', to: 'in_progress_jobs#index', as: :in_progress_jobs

  # Application Process
  resources :application_processes, only: %i[create show] do
    get '/overview', to: 'overview_application_processes#show'
    get '/payload', to: 'payload_application_processes#show'
    resources :job_applications, only: %i[edit update]
  end

  resource :user_details, only: %i[edit update]
end
