Rails.application.routes.draw do
  root 'pages#index'

  resources :floors

  get '*path' => redirect('/')
end
