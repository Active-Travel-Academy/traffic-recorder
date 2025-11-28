Rails.application.routes.draw do
  resources :point_of_interests, only: [] do
    collection do
      get :search
    end
  end
  resources :ltns do
    member do
      post :enable_journeys
      post :disable_journeys
      post :test_journeys
    end
    resources :journey_run_downloads
    resources :journeys_uploads, only: :create
    resources :journeys
    resources :origins, :point_of_interests, except: :index do
      member do
        post :enable_journeys
        post :disable_journeys
        post :test_journeys
      end
    end
    resources :points_of_interest_and_origins, only: %i[index create]
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
