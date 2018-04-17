class MemberNotifications < ActionMailer::Base

  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz,jiri@kubicek.cz",
          content_transfer_encoding: 'text/plain'

  layout "mail"

  def paid(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

  def registered(person)
    @person = person
    mail to: @person.email, subject: "Potvrzení registrace, další kroky"
  end

  def regular(person)
    @person = person
    mail to: @person.email, subject: "Vítáme nového člena"
  end

  def rejected(person)
    @person = person
    mail to: @person.email, subject: "Zamítnutí členství"
  end

  def renewed(person)
    @person = person
    mail to: @person.email, subject: "Prodloužení členství"
  end

  def supporter_membership_requested(person)
    @person = person
    mail to: @person.email, subject: "Potvrzení registrace, další kroky"
  end

  def supporter_paid(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

  # FIXME
  def supporter_payment_pending(person)
    @person = person
    mail to: @person.email, subject: "Vaše úhrada byla úspěšně zpracována"
  end

  def supporter_rejected(person)
    @person = person
    mail to: @person.email, subject: "Zamítnutí členství"
  end
end
