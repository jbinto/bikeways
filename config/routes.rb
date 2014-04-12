Bikeways::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :bikeway_segments
end