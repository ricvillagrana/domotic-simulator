Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :rooms
  resources :devices
  resources :device_types
  resources :networks
  resources :interfaces
  resources :unit_types
  resources :sensors
  resources :actuators

  put '/devices/:id/sensors', to: 'devices#append_sensor'
  delete '/devices/:id/sensors/:sensor_id', to: 'devices#remove_sensor'

  put '/devices/:id/actuators', to: 'devices#append_actuator'
  delete '/devices/:id/actuators/:actuator_id', to: 'devices#remove_actuator'

  put '/devices/:id/interfaces', to: 'devices#append_interface'
  delete '/devices/:id/interfaces/:interface_id', to: 'devices#remove_interface'


  get '/simulation', to: 'pages#simulation'

  # get '*path' => redirect('/')
end
