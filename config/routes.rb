Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :games, only: [] do
        member do
          post 'bid'
          post 'bs'
          post 'comments'
          get 'events'
        end
      end
    end
  end

  resources :games do
    member do
      post 'invite'
      post 'start'
    end
  end

  resources :invites, only: [] do
    member do
      post 'accept'
      post 'decline'
      post 'revoke'
    end
  end

  root to: "games#index"
end
