RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    member :application do
      #i18n_key :application
      only Person
      route_fragment '/application.pdf'
      controller PeopleController
      pjax false
      #action_name '../people/'
    end
    # except Stuff, Stuff2

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Region' do 
    list do
      field :name do
        label "Název kraje"
      end
    end

    show do
    #  label "Název kraje"
      field :name
      field :branches
    end
    weight 10
  end

  config.model 'Branch' do
    navigation_label 'Pobočky'
    list do
      field :name
      field :region
    end
    weight 100
  end

end
