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
    member do
      get 'coordinator'
      get 'map'
      get 'awaiting_domestic_people'
      get 'domestic_members'
      get 'domestic_supporters'
      get 'guest_people'
    end
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
    resources :people
    resources :branches, only: :index
    resources :contacts, only: :index
    resource :body, only: :show
    member do
      get 'mestske_casti'
      get 'okresy'
      get 'map'
      get 'awaiting_domestic_people'
    end
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
