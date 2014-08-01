Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do
      post 'bid'
      post 'bs'
      get 'events'
      post 'invite'
      post 'join'
      post 'start'
    end
  end

  root to: "games#index"
end
