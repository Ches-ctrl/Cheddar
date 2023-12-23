Rails.application.routes.draw do
  require "sidekiq/web"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: "pages#home"
  get 'profile', to: 'users#show', as: 'profile'
  get "up" => "rails/health#show", as: :rails_health_check
  get "about" => "pages#about"
  get "test" => "pages#test"
  get "faqs" => "pages#faqs"
  get "howitworks" => "pages#how_it_works", as: :how_it_works
  get "success" => "pages#success", as: :success
  get '/jobs', to: 'jobs#index', as: :jobs
  post '/chatbot/chat', to: 'messages#chat'

  resources :jobs, only: [:show, :create] do
    resources :saved_jobs, only: [:create]
    collection do
      post :apply_to_selected_jobs, as: :apply
    end
    # TODO: fix app if breaking because you'll now need to specify the job in params
    resources :job_applications, only: [:create]
  end

  resources :companies, only: [:index, :show]
  resources :job_applications, only: [:index, :show, :new, :success] do
    member do
      get :status
    end
  end

  # get '/jobs/:id/find_job_application/:user_id', to: 'jobs#find_job_application', as: :find_job_application

  resources :saved_jobs, only: [:index, :show, :destroy]
  resources :educations, only: [:new, :create]

end
