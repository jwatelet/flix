Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'movies#index'

  resources :movies do
    resources :reviews
  end

  resources :users
  resource :session, only: [:new, :create, :destroy]

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
end
