# http://tools.ietf.org/html/draft-jones-json-web-token-10
# http://jwt.io/#libraries

class AuthController < ApplicationController

  before_action :authenticate_person!, except: [:public_key, :me]
  before_action :doorkeeper_authorize!, only: [:me]

  # GET /auth/token.json
  def token
    authorize!(:jwt_token, current_person)
    subject = "db|#{current_user.id}"
    now = Time.now
    @payload = {
      iss: "https://registr.svobodni.cz",
      sub: subject,
      nbf: now.to_i,
      exp: (now+1.hour).to_i,
      iat: now.to_i,
      jti: SecureRandom.uuid,
      typ: "https://registr.svobodni.cz/auth"
    }

    if params[:redirect_uri]
      if system = configatron.auth.systems.detect{|handle, uri| uri == params[:redirect_uri]}
        @payload[:aud] = system.first
      else
        @payload[:aud] = params[:redirect_uri]
      end
    end

    @token = JWT.encode(@payload, configatron.auth.private_key, "RS256")
    IssuedTokenLogEntry.create!(
      person: current_user,
      issued_at: now,
      token_id: @payload[:jti],
      audience: @payload[:aud],
      ip_address: request.remote_ip
    )

    respond_to do |format|
      format.html {
        #uri = URI.parse(params[:redirect_uri])
        redirect_to (params[:redirect_uri]+"?jwt="+@token)
      }
      format.json {render text: @token}
    end
  end


  # GET /auth/public_key
  def public_key
    public_key = configatron.auth.private_key.public_key.to_s
    render text: public_key
  end

  # GET /auth/me
  def me
    @person = current_person
    respond_to do |format|
      format.json {render template: "people/profile"}
    end
  end

  # GET /auth/profile
  def profile
    @person = current_person
    respond_to do |format|
      format.json {render template: "people/profile"}
    end
  end

end
