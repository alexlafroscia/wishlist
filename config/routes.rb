Rails.application.routes.draw do
  resources :lists
  mount_ember_app :frontend, to: '/'
end
