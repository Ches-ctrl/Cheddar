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
  # root to: "pages#home"
  get 'about', to: 'pages#about', as: 'about'
  get 'faqs', to: 'pages#faqs', as: 'faqs'
  get 'how_it_works', to: 'pages#how_it_works', as: 'how_it_works'
  get 'landing', to: 'pages#landing', as: 'landing'
  get 'privacy', to: 'pages#privacy', as: 'privacy'

  get 'ts&cs', to: 'pages#ts_and_cs', as: 'ts_and_cs'

  # Jobs
  get '/jobs/add_job', to: 'jobs#add_job'

  # Chatbot
  post '/chatbot/chat', to: 'messages#chat'

  # Resources

  resources :companies, only: %i[index show]
  # resources :job_applications, only: %i[index show new success create] do
  #   member do
  #     get :status
  #   end
  # end

  resources :emails, only: [:create]
  resources :educations, only: %i[new create]

  ###
  ### Taimwind Protocal Template
  ###
  get 'protocol', to: 'pages#protocol', as: 'protocol'

  ###
  ### Integration of new template
  ###

  get 'basket', to: 'saved_jobs#index', as: :saved_jobs
  get 'in_progress', to: 'in_progress_jobs#index', as: :in_progress_jobs

  resources :application_processes, only: %i[create show] do
    get '/overview', to: 'overview_application_processes#show'
    resources :job_applications, only: %i[edit update]
  end

  resources :opportunities, path: '/jobs', only: %i[index show] do
    resources :saved_jobs, only: %i[create]
    delete '/saved_jobs', to: 'saved_jobs#destroy', as: :destroy_saved_jobs
    collection do
      get 'opportunity_autocomplete', to: 'opportunity_autocomplete#index'
    end
  end

  root to: 'uncategorized_pages#tothemoon'
end
