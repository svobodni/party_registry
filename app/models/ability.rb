class Ability
  include CanCan::Ability

  def initialize(user)

    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard

    can [:read, :update], Person, :id => user.id
    can :read, [Body, Branch, Region, Role]

    can :read, Contact, privacy: 'public'
    can [:create, :update, :destroy], Contact, {contactable_id: user.id, contactable_type: 'Person'}
#    user ||= User.new # guest user (not logged in)

    user.roles.each do |role|
      if role.type == "Coordinator"
        # Koordinátor pobočky
        can [:read, :application, :export], Person, guest_branch_id: role.branch_id
        can [:read, :application, :export], Person, domestic_branch_id: role.branch_id
        can [:supervise], Branch, id: role.branch_id
      elsif (role.type == "President" || role.type == "Vicepresident") && role.body.organization.type=="Region"
        # Členové krajského předsednictva
        can [:read, :application, :export, :update], Person, domestic_region_id: role.body.organization_id
        can [:read, :application, :export], Person, guest_region_id: role.body.organization_id
        can [:create, :update, :destroy, :supervise], Branch, parent_id: role.body.organization_id
        can [:supervise], Region, id: role.body.organization_id
      elsif (role.type == "President" || role.type == "Vicepresident") && role.body.organization.type=="Country"
        # Členové republikového předsednictva
        can :manage, :all
      end
    end

    if user.is_regular_member?
      can :read, Contact, privacy: ['members','supporters']
    elsif user.is_regular_supporter?
      can :read, Contact, privacy: 'supporters'
    end

    if user.id==342
      can :upload, SignedApplication
    end

  end
end
