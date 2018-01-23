Rails.application.routes.draw do

  namespace :backoffice do
    resources :attendance_lists, only: [:new, :create, :show] do
      member do
        get :guests
      end
    end
    resources :events, only: [:index, :show]
    resources :stats, only: [:index] do
      collection do
        get 'changes'
      end
    end
    resources :people do
      collection do
        get 'addresses'
      end
      member do
        post 'paid'
      end
      collection do
        get :autocomplete_person_id
        get :autocomplete_person_email
        get :autocomplete_person_name
        get :autocomplete_person_phone
        get :with_unknown_address
        get :with_bad_region
        get :without_signed_application
        get :members_without_signed_application
        get :new_registrations
      end
    end
  end

  resources :profiles do
    collection do
      get 'personal'
      get 'photos'
      get 'credentials'
      get 'addresses'
      get 'contacts'
      get 'guesting'
      get 'membership'
    end
  end

  get '/registrations/member', to: 'registrations#member'
  get '/registrations/supporter', to: 'registrations#supporter'

  patch '/profiles', to: 'profiles#update'
  use_doorkeeper

  resources :profile_pictures
  resources :contacts
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :signed_applications
  resources :profile_photos

  get '/auth/token'
  get '/auth/public_key'
  get '/auth/profile'
  get '/auth/me'

  devise_for :people, :controllers => { :omniauth_callbacks => "people/omniauth_callbacks" }

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
      get 'unpaid_domestic_members'
    end
  end
  resources :organizations
  resources :people do
    resources :contacts
    resources :notes, only: [:new, :create]

    member do
      get 'application'
      get 'signed_application'
      get 'private'
      get 'photo'
      get 'cv'
      post 'approve'
      post 'cancel_membership'
      get 'cancel_membership_request'
    end
    collection do
      get 'profile'
      get 'dashboard'
      get 'beran_export'
    end
  end

  resources :supporter_memberships, only: [:new, :create]

  resources :regions do
    resources :people
    resources :branches, only: :index
    resources :councilors, only: :index
    resources :contacts, only: :index
    resource :body, only: :show
    member do
      get 'domestic_members'
      get 'domestic_supporters'
      get 'guest_people'
      get 'mestske_casti'
      get 'okresy'
      get 'map'
      get 'awaiting_domestic_people'
      get 'unpaid_domestic_members'
    end
  end

  resources :regions, path: "kraje"
  resources :councilors, path: "zastupitele"
  resources :councilors, only: :index

  post "/people/:id/payments", to: "finance_api#payments"
  post "/people/:id/paid", to: "finance_api#paid"

  root 'people#dashboard'
end
