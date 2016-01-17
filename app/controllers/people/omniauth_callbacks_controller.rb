class People::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_action :verify_authenticity_token, only: [:mojeid, :trezor]

  def twitter
    default_callback
  end

  def facebook
    default_callback
  end

  def mojeid
    default_callback
  end

  def trezor
    default_callback
  end

  private
  def default_callback
    provider = request.env["omniauth.auth"].provider
    uid = request.env["omniauth.auth"].uid
    identity = Identity.find_by_provider_and_uid(provider, uid)
    if identity
      # zname -> prihlasime
      sign_in_and_redirect identity.person, :event => :authentication
    else
      # nezname -> priradime nebo registrujeme
      if current_user
        current_user.identities.create(provider: provider, uid: uid)
        redirect_to credentials_profiles_path, notice: "#{provider} účet byl úspěšně navázán."
      else
        # TODO uchovat fb data
        # session["devise.facebook_data"] = request.env["omniauth.auth"]
        # redirect_to new_person_registration_url
        redirect_to new_person_session_path, notice: "Neznámý #{provider} účet. Nejprve se prosím přihlašte nebo zaregistrujte a provažte Váš účet, abyste se v budoucnu mohl/a přihlašovat přes #{provider}."
      end
    end
  end
end
