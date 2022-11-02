Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  resources :users
  get 'signup' => 'users#new'
end
