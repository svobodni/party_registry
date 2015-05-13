class RegistrationsController < ApplicationController

  before_action :authenticate_person!, except: [:member, :supporter]

  # GET /registrations/member
  def member
    redirect_to new_person_registration_path
  end

  # GET /registrations/supporter
  def supporter
    redirect_to new_person_registration_path(type: :supporter)
  end

end
