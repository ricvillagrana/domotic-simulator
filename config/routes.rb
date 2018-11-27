Rails.application.routes.draw do
  root 'pages#index'

  resources :floors
  resources :rooms
  resources :devices
  resources :device_types
  resources :networks
  resources :interfaces
  resources :unit_types
  resources :environments
  resources :sensors
  resources :actuators

  get '/floors/:id/rooms', to: 'floors#rooms'
  get '/rooms/:id/devices', to: 'rooms#devices'

  put '/rooms/:id/append_environment/:environment_id', to: 'rooms#append_environment'
  delete '/rooms/:id/remove_environment/:environment_id', to: 'rooms#remove_environment'

  put '/rooms/:id/append_device/:device_id', to: 'rooms#append_device'
  delete '/rooms/:id/remove_device/:device_id', to: 'rooms#remove_device'

  put '/devices/:id/sensors', to: 'devices#append_sensor'
  delete '/devices/:id/sensors/:sensor_id', to: 'devices#remove_sensor'

  put '/devices/:id/actuators', to: 'devices#append_actuator'
  delete '/devices/:id/actuators/:actuator_id', to: 'devices#remove_actuator'

  put '/devices/:id/interfaces', to: 'devices#append_interface'
  delete '/devices/:id/interfaces/:interface_id', to: 'devices#remove_interface'


  get '/simulation', to: 'pages#simulation'

  # get '*path' => redirect('/')
end
