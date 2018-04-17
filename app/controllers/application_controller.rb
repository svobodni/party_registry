class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate_person!
  before_action :load_country
  before_action :prepare_exception_notifier

  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_user
  	current_person
  end

  rescue_from CanCan::AccessDenied, :with => :authorization_error
  rescue_from JWT::DecodeError, :with => :authorization_error

  def authorization_error
    # 403 Forbidden response
    respond_to do |format|
      format.html{ render text: 'Access Denied', status: 403 }
      format.json{ render json: {error: 'Access Denied'}, status: 403 }
    end
  end

  def authenticate_person!
    if request.headers['Authorization']
      authorize_token!
    else
      super
    end unless doorkeeper_token && doorkeeper_token.accessible?
  end

  def current_person
    if doorkeeper_token && doorkeeper_token.accessible?
      Person.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def after_sign_in_path_for(resource)
    if current_person.is_regular_member? || current_person.is_regular_supporter?
      #request.env['omniauth.origin'] || stored_location_for(resource) || root_path
      super
    else
      membership_profiles_path
    end
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      :current_person_id => current_person.try(:id)
    }
  end

  def authorize_token!
    token = request.headers['Authorization'].split(' ').last

    jwt = JWT.decode(token, nil, false)
    raise CanCan::AccessDenied unless jwt.last['alg']=="RS256" && jwt.last['typ']=="JWT"

    jwt = JWT.decode(token, configatron.auth.private_key.public_key, true).first
    @current_person = Person.find(jwt['sub'].split('|').last)
  end
  def load_country
    @country = Country.first
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:legacy_type, :first_name, :last_name, :date_of_birth, :phone, :domestic_address_street, :domestic_address_city, :domestic_address_zip, :domestic_region_id, :postal_address_street, :postal_address_city, :postal_address_zip, :guest_region_id, :username, :email, :password, :password_confirmation, :remember_me, :agree, :amount, :previous_political_parties, :previous_candidatures) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  def default_event_params
    {
    requestor_id: current_person.id,
    params: params,
    controller_path: controller_path,
    action_name: action_name,
    remote_ip: request.remote_ip,
    referer: request.referer
    }
  end

end
