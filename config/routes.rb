Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
end
