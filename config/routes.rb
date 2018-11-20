Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :networks
  resources :interfaces
  resources :unit_types

  # get '*path' => redirect('/')
end
