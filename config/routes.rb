Rails.application.routes.draw do
  get 'finance/index'

  resources :stocks

  root 'finance#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
