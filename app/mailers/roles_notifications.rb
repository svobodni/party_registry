class RolesNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
  bcc: "kubicek@svobodni.cz",
  content_transfer_encoding: 'text/plain'

  def reminder(role)
    @role = role
    if role.body.organization==Country.first
      mail to: "predseda@svobodni.cz"
    else
      mail to: role.body.presidium_emails
    end
  end
end
