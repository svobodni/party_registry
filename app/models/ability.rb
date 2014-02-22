class Ability
  include CanCan::Ability

  def initialize(user)

    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard

    can [:read, :update], Person, :id => user.id
    can [:read], Region
    can :read, Branch

#    user ||= User.new # guest user (not logged in)

    user.roles.each do |role|
      if role.type == "Coordinator"
        # Koordinátor pobočky
        can [:read, :application], Person, guest_branch_id: role.branch_id
        can [:read, :application], Person, domestic_branch_id: role.branch_id
      elsif (role.type == "Chairman" || role.type == "ViceChairman") && role.body.organization.type=="Region"
        # Členové krajského předsednictva
        can [:read, :update, :application], Person, guest_region_id: role.body.organization_id
        can [:read, :update, :application], Person, domestic_region_id: role.body.organization_id
      elsif (role.type == "Chairman" || role.type == "ViceChairman") && role.body.organization.type=="Country"
        # Členové republikového předsednictva
        can [:read, :update], Person
      end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
