Rails.application.routes.draw do
  resources :ltns do
    member do
      post :enable_page_journeys
      post :disable_page_journeys
      post :enable_all_journeys
      post :disable_all_journeys
    end
    resources :journey_run_downloads
    resources :journeys_uploads, only: :create
    resources :journeys
  end

  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "ltns#index"
end
