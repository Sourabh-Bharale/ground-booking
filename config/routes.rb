Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post "/sign_up" => "users#create"
  post "/sign_in" => "auth#login"

  get "/user/registrations" => "users#current_user_registrations"
  get "/users/:user_id/registrations" => "users#all_registrations"
  get "/users" => "users#search"

  resources :registrations do
    resources :payments
  end

  resources :events do
    resources :slots do
      resources :registrations
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
