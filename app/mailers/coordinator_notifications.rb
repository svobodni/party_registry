class CoordinatorNotifications < ActionMailer::Base
  default from: "kancelar@svobodni.cz",
          bcc: "kubicek@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def guesting_person_joined(person)
    @person = person
    @branch = @person.guest_branch
    @coordinator = @branch.coordinator
    mail to: @coordinator.person.email
  end

  def daily_event_notifier(branch, events)
    @events = events
    @branch = branch
    mail to: branch.coordinator.person.email, subject: "svobodni.cz - notifikace změn"
  end

end
