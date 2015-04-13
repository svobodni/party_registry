class RolesNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
  bcc: "kubicek@svobodni.cz",
  content_transfer_encoding: 'text/plain'

  def reminder(role)
    @role = role
    if role.body.organization==Country.first
      mail to: "predseda@svobodni.cz"
    else
      emails = role.body.vicepresidents.collect{|vp| vp.person.email}
      emails<< role.body.president.try(:person).try(:email)
      mail to: emails
    end
  end
end
