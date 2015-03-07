PartyRegistry::Application.routes.draw do

  use_doorkeeper

  resources :contacts

  resources :signed_applications

  get '/auth/token'
  get '/auth/public_key'
  get '/auth/profile'
  get '/auth/me'

  devise_for :people

  resources :webdav_passwords
  resources :bodies
  resources :roles, only: [:index, :destroy, :new, :create] do
    get :autocomplete_person_last_name, :on => :collection
  end

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
      get 'private'
      get 'photo'
      get 'cv'
    end
    collection do
      get 'profile'
      get 'dashboard'
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


  root 'people#dashboard'
end
