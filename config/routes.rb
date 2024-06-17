Rails.application.routes.draw do
  require "sidekiq/web"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => "/cable" # TODO: fix as not found at the moment
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
  # root to: "pages#home"
  get 'about', to: 'pages#about', as: 'about'
  get 'faqs', to: 'pages#faqs', as: 'faqs'
  get 'how_it_works', to: 'pages#how_it_works', as: 'how_it_works'
  get 'landing', to: 'pages#landing', as: 'landing'
  get 'privacy', to: 'pages#privacy', as: 'privacy'

  get 'ts&cs', to: 'pages#ts_and_cs', as: 'ts_and_cs'

  # Users
  get 'profile', to: 'users#show', as: 'profile'

  # Jobs
  get '/jobs/add_job', to: 'jobs#add_job'

  # Chatbot
  post '/chatbot/chat', to: 'messages#chat'

  # Resources
  # resources :jobs, only: %i[index show create] do
  #   resources :saved_jobs, only: [:create]
  #   collection do
  #     post :apply_to_selected_jobs, as: :apply
  #   end
  #   # TODO: fix app if breaking because you'll now need to specify the job in params
  #   resources :job_applications, only: [:create]
  # end

  resources :companies, only: %i[index show]
  resources :job_applications, only: %i[index show new success create] do
    member do
      get :status
    end
  end

  resources :emails, only: [:create]
  resources :saved_jobs, only: %i[index show destroy]
  resources :educations, only: %i[new create]

  ###
  ### Taimwind Protocal Template
  ###
  get 'protocol', to: 'pages#protocol', as: 'protocol'
  resources :quick_start, only: %i[index]
  resources :sdks, only: %i[index]
  resources :authentication, only: %i[index]
  resources :pagination, only: %i[index]
  resources :errors, only: %i[index]
  resources :webhooks, only: %i[index]
  resources :contacts, only: %i[index]
  resources :conversations, only: %i[index]
  resources :messages, only: %i[index]
  resources :groups, only: %i[index]
  resources :attachements, only: %i[index]

  ###
  ### Integration of new template
  ###

  # get 'opportunities', to: 'opportunities#protocol', as: 'protocol'
  # resources :opportunities, only: %i[index]
  # get '/opportunities/opportunity_autocomplete', to: 'opportunity_autocomplete#index'
  resources :opportunities, path: '/jobs', only: %i[index show] do
    collection do
      get 'opportunity_autocomplete', to: 'opportunity_autocomplete#index'
    end
  end

  root to: 'uncategorized_pages#tothemoon'
  # get '/tothemoon', to: 'uncategorized_pages#tothemoon'
  # get '/template/users/sign_in', to: 'devise/sessions#new', as: :new_template_user_session
  devise_scope :user do
    get "/template/users/edit", to: "devise/registrations#edit", as: :edit_template_user_registration_path
    get "/template/users/sign_in", to: "devise/sessions#new", as: :new_template_user_session
    get "/template/users/password/new", to: "devise/passwords#new", as: :new_template_user_password
    get "/template/users/sign_up", to: "devise/registrations#new", as: :new_template_user_registration
  end
end
