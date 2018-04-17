class OfficeNotifications < ApplicationMailer

  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz,jiri@kubicek.cz",
          content_transfer_encoding: 'text/plain'

  def membership_request_rejected(person)
    @person = person
    mail to: "kancelar@svobodni.cz", subject: "Zamítnuté členství - vraťte platbu"
  end

end
