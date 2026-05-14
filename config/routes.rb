Rails.application.routes.draw do
  root "home#index"

  resource :session
  resources :passwords, param: :token
  resources :registration, only: %i[new create]
end
