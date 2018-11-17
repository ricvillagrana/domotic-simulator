Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :networks

  get '*path' => redirect('/')
end
