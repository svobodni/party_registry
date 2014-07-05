# http://tools.ietf.org/html/draft-jones-json-web-token-10
# http://jwt.io/#libraries

class AuthController < ApplicationController

  before_action :authenticate_person!, except: [:public_key, :profile]
  before_action :validate_token, only: :profile

  # GET /token.json
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
    @token = JWT.encode(@payload, configatron.auth.private_key, "RS256")

    respond_to do |format|
      format.html {
        uri = URI.parse(params[:redirect_uri])
        redirect_to (params[:redirect_uri]+"?jwt="+@token)
      }
      format.json {render text: @token}
    end
  end

  def public_key
    public_key = configatron.auth.private_key.public_key.to_s
    render text: public_key
  end

  def profile
    @person = Person.find(@jwt['sub'].split('|').last)
    respond_to do |format|
      format.json {render template: "people/profile"}
    end
  end

private
  def validate_token
    begin
      token = request.headers['Authorization'].split(' ').last
      @jwt = JWT.decode(token, configatron.auth.private_key, nil).first
    rescue JWT::DecodeError
      render nothing: true, status: :unauthorized
    end
  end
end
