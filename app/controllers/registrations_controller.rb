class RegistrationsController < ApplicationController

  before_action :authenticate_person!, except: [:member, :supporter]

  # GET /registrations/member
  def member
    redirect_to "https://www.svobodni.cz/clenstvi/clen/"
  end

  # GET /registrations/supporter
  def supporter
    redirect_to "https://www.svobodni.cz/clenstvi/priznivec/"
  end

end
