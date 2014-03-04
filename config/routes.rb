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

  root 'welcome#index'
end
