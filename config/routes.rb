PartyRegistry::Application.routes.draw do
  get '/admin/person/:id/application' => 'people#application'

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :people

  resources :bodies
  resources :branches do
    resources :people
  end
  resources :organizations
  resources :people do
    member do
      get 'application'
    end
  end
  resources :regions do
    resources :branches
    resources :people
  end

  get 'server' => 'server#index'
  post 'server' => 'server#index'
  get 'server/xrds' => 'server#idp_xrds'
  get 'user/:username' => 'server#user_page'
  get 'user/:username/xrds' => 'server#user_xrds'
  get 'server/decision' => 'server#decision'
  post 'server/decision' => 'server#decision'

  root 'welcome#index'
end
