class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate_person!

  def current_user
  	current_person
  end

  rescue_from CanCan::AccessDenied, :with => :authorization_error
  rescue_from JWT::DecodeError, :with => :authorization_error

  def authorization_error
    # 403 Forbidden response
    respond_to do |format|
      format.json{ render json: {error: 'Access Denied'}, status: 403 }
    end
  end

  def authenticate_person!
    if request.headers['Authorization']
      authorize_token!
    else
      super
    end
  end

  def authorize_token!
    token = request.headers['Authorization'].split(' ').last

    jwt = JWT.decode(token, nil, false)
    raise CanCan::AccessDenied unless jwt.last['alg']=="RS256" && jwt.last['typ']=="JWT"

    jwt = JWT.decode(token, configatron.auth.private_key.public_key, true).first
    @current_person = Person.find(jwt['sub'].split('|').last)
  end
end
