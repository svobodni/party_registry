# http://tools.ietf.org/html/draft-jones-json-web-token-10
# http://jwt.io/#libraries

class AuthController < ApplicationController

  before_action :authenticate_person!, except: [:public_key]

  # GET /auth/token.json
  def token
    subject = "db|#{current_user.id}"
    @payload = {
      iss: "https://registr.svobodni.cz",
      sub: subject,
      nbf: Time.now.to_i,
      exp: (Time.now+1.hour).to_i,
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      typ: "https://registr.svobodni.cz/auth"
    }

    if params[:redirect_uri]
      if system = configatron.auth.systems.detect{|handle, uri| uri == params[:redirect_uri]}
        @payload[:aud] = system.first
      end
    end

    @token = JWT.encode(@payload, configatron.auth.private_key, "RS256")

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

  # GET /auth/profile
  def profile
    @person = current_person
    respond_to do |format|
      format.json {render template: "people/profile"}
    end
  end

end
