Bikeways::Application.routes.draw do
  #devise_for :users, :controllers => {:registrations => "registrations"}
  #resources :users

  root :to => "segments#index"
  resources :segments
end