class MemberNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def accepted(person)
    @person = person
    mail to: @person.email, subject: "Krajské předsednictvo schválilo Vaše členství"
  end

  def reminder(person)
    @person = person
    @event = person.events.where("events.name = 'PersonAccepted'").try(:last)
    mail to: @person.email, subject: "Úhrada členského příspěvku"
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
