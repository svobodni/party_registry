class CoordinatorNotifications < ActionMailer::Base
  default from: "kubicek@svobodni.cz",
          bcc: "kubicek@svobodni.cz",
          content_transfer_encoding: 'text/plain'

  def guesting_person_joined(person)
    @person = person
    @branch = @person.guest_branch
    @coordinator = @branch.coordinator
    mail to: @coordinator.person.email
  end
end
