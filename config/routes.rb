Rails.application.routes.draw do
  get 'finance', to: 'finance#index'
  get 'finance/now', to: 'finance#now'

  post 'finance', to: 'finance#update'

  resources :stocks

  root 'finance#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
