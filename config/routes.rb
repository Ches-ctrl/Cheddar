Rails.application.routes.draw do
  require "sidekiq/web"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable"
  mount Avo::Engine, at: '/avo'

  devise_for :users, except: [:fetch_template]
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
  root to: "pages#home"
  get 'landing', to: 'pages#landing', as: 'landing'
  get 'about', to: 'pages#about', as: 'about'
  get 'how_it_works', to: 'pages#how_it_works', as: 'how_it_works'
  get 'privacy', to: 'pages#privacy', as: 'privacy'
  get 'ts&cs', to: 'pages#ts_and_cs', as: 'ts_and_cs'

  # Users
  get 'profile', to: 'users#show', as: 'profile'

  # Jobs
  get '/jobs/add_job', to: 'jobs#add_job'

  # Chatbot
  post '/chatbot/chat', to: 'messages#chat'

  # Resources
  resources :jobs, only: [:index, :show, :create] do
    resources :saved_jobs, only: [:create]
    collection do
      post :apply_to_selected_jobs, as: :apply
    end
    # TODO: fix app if breaking because you'll now need to specify the job in params
    resources :job_applications, only: [:create]
  end

  resources :companies, only: [:index, :show]
  resources :job_applications, only: [:index, :show, :new, :success, :create] do
    member do
      get :status
    end
  end

  resources :saved_jobs, only: [:index, :show, :destroy]
  resources :educations, only: [:new, :create]
end
