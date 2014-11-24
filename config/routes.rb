PartyRegistry::Application.routes.draw do
  resources :contacts

  resources :signed_applications

  get '/admin/person/:id/application' => 'people#application'
  get '/auth/token'
  get '/auth/public_key'
  get '/auth/profile'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :people

  resources :webdav_passwords
  resources :bodies
  resources :branches do
    resources :people
    resources :contacts, only: :index
  end
  resources :organizations
  resources :people do
    resources :contacts
    member do
      get 'application'
      get 'signed_application'
    end
    collection do
      get 'profile'
    end
  end
  resources :regions do
    resources :branches
    resources :people
    resources :contacts, only: :index
  end

  get 'server' => 'server#index'
  post 'server' => 'server#index'
  get 'server/xrds' => 'server#idp_xrds'
  get 'user/:username' => 'server#user_page'
  get 'user/:username/xrds' => 'server#user_xrds'
  get 'server/decision' => 'server#decision'
  post 'server/decision' => 'server#decision'

  root 'regions#index'
end
