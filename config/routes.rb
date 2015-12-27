Rails.application.routes.draw do
  namespace :api do
    get 'session', to: 'session#get'
    post 'session', to: 'session#create'
    delete 'session', to: 'session#destroy'
  end

  scope '/api' do
    jsonapi_resources :users
    jsonapi_resources :lists do
      jsonapi_links :owner, only: [:show]
      jsonapi_related_resource :owner
    end

    match '*not_found', to: 'application#routing_error', via: :all
  end

  mount_ember_app :frontend, to: '/'
end
