class PresidiumNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "notifikace@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def member_registered(person)
    @person = person
    mail to: @person.domestic_region.presidium.presidium_emails, subject: "svobodni.cz - nový zájemce o členství"
  end

  def requesting_paid(person)
    @person = person
    mail to: @person.domestic_region.presidium.presidium_emails, subject: "svobodni.cz - zájemce o členství zaplatil"
  end

  def new_regular_member(person)
    @person = person
    mail to: @person.domestic_region.presidium.presidium_emails, subject: "svobodni.cz - nový člen"
  end

  def new_regular_supporter(person)
    @person = person
    mail to: @person.domestic_region.presidium.presidium_emails, subject: "svobodni.cz - nový příznivec zaplatil"
  end

  def daily_event_notifier(region, events)
    @events = events
    mail to: region.presidium.presidium_emails, subject: "svobodni.cz - notifikace změn"
  end
end
