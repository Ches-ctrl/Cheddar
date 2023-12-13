Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users

  root to: "pages#home"
  get 'profile', to: 'users#show', as: 'profile'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "about" => "pages#about"
  get "test" => "pages#test"
  get "faqs" => "pages#faqs"
  get "howitworks" => "pages#how_it_works", as: :how_it_works
  get "success" => "pages#success", as: :success
  post '/chatbot/chat', to: 'messages#chat'

  # Defines the root path route ("/")
  # root "posts#index"

  resources :companies, only: [:index, :show]
  resources :jobs, only: [:index, :show, :create] do
    resources :saved_jobs, only: [:create]
    collection do
      post :apply_to_selected_jobs, as: :apply
    end
    # TODO: fix app if breaking because you'll now need to specify the job in params
    resources :job_applications, only: [:create]
  end

  resources :job_applications, only: [:index, :show, :new, :success]

  resources :saved_jobs, only: [:index, :show, :destroy]
  resources :educations, only: [:new, :create]

end
