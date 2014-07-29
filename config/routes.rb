Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do
      get 'events'
      post 'join'
      post 'start'
      post 'bid'
      post 'bs'
    end
  end

  root to: "games#index"
end
