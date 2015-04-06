class CoordinatorNotifications < ActionMailer::Base
  default from: "from@example.com",
          content_transfer_encoding: 'text/plain'

  def guesting_person_joined(person)
    @person = person
    @branch = @person.guest_branch
    @coordinator = @branch.coordinator
    mail to: @coordinator.person.email
  end
end
