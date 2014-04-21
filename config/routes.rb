Bikeways::Application.routes.draw do
  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users

  resources :bikeway_segments do
    # http://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper/Resources.html#method-i-member
    member do
      get 'next'
      get 'prev'
    end
  end

end