class MemberNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "kubicek@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def accepted(person)
    @person = person
    mail to: @person.email, subject: "Krajské předsednictvo schválilo Vaše členství"
  end

end
