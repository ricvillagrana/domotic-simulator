Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :networks
  resources :interfaces

  # get '*path' => redirect('/')
end
