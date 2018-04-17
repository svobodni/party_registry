class MigrationNotifications < ActionMailer::Base

  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz,jiri@kubicek.cz",
          content_transfer_encoding: 'text/plain'

  def older(person)
    @person = person
    mail to: @person.email, subject: "Žádost o členství byla ukončena"
  end

  def newer(person)
    @person = person
    mail to: @person.email, subject: "Zjednodušený systém přijímání, staňte se dočasně příznivcem"
  end

end
