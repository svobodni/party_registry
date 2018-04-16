class SupporterNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  layout "mail"

  def registered(person)
    @person = person
    mail to: @person.email, subject: "Potvrzení registrace, další kroky"
  end

  def regular(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

  def renewed(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

end
