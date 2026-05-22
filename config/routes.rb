Rails.application.routes.draw do
  root "home#index"

  resource :session, only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update], param: :token
  resources :registration, only: %i[new create]
end
