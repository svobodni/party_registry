class SupporterNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "kubicek@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def regular(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

  def renewed(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

end
