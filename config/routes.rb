Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'

  root 'static_pages#home'

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get '/home' ,to: "static_pages#home"
  get '/help' ,to: "static_pages#help" , as: "help"
  get '/about' ,to: "static_pages#about"
  get '/contact' ,to: "static_pages#contact"
  get '/signup' ,to: "users#new"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  resources :users
  resources :account_activations, only: [:edit]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end


