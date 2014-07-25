Rails.application.routes.draw do
  devise_for :users

  resources :games do
    member do
      post 'start'
    end
  end

  root to: "home#index"
end
