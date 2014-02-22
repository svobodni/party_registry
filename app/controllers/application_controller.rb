class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate_person!


  def current_user
  	current_person
  end

  rescue_from CanCan::AccessDenied, :with => :authorization_error

  def authorization_error
    # 403 Forbidden response
    respond_to do |format|
      format.json{ render :json => 'Access Denied', :status => 403 }
    end
  end
end
