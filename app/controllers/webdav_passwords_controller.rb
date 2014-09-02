# -*- encoding : utf-8 -*-
class WebdavPasswordsController < ApplicationController

  before_action :authenticate_person!

  def create
    subject = "db|#{current_user.id}"
    @payload = {
      iss: "https://registr.svobodni.cz",
      sub: subject,
      nbf: Time.now.to_i,
      iat: Time.now.to_i,
      jti: SecureRandom.uuid,
      aud: 'webdav',
      typ: "https://registr.svobodni.cz/auth"
    }
    @password = SecureRandom.hex(10)
    @token = JWT.encode(@payload, configatron.auth.private_key, "RS256")
    response = HTTParty.post(configatron.webdav.post_uri,
        body: {
          jwt: @token,
          pwd: Digest::SHA1.hexdigest(@password)
        }
    )

    if response.code == 200
      redirect_to profile_people_path, flash: { password: @password }
    else
      flash[:error] = "Vytvoření hesla selhalo, zkuste to prosím později."
      redirect_to profile_people_path
    end
    
  end

end
