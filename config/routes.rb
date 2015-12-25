Rails.application.routes.draw do
  namespace :api do
    get 'session', to: 'session#get'
    post 'session', to: 'session#create'
    delete 'session', to: 'session#destroy'
  end

  scope '/api' do
    jsonapi_resources :user
    jsonapi_resources :list
  end

  mount_ember_app :frontend, to: '/'
end
