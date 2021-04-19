require 'test_helper'

class OfficeNotificationsTest < ActionMailer::TestCase
  test "membership_request_rejected" do
    mail = OfficeNotifications.membership_request_rejected(FactoryBot.create(:registered_requesting_membership))
    assert_equal "Zamítnuté členství - vraťte platbu", mail.subject
    assert_equal ["kancelar@svobodni.cz"], mail.to
    assert_equal ["kancelar@svobodni.cz"], mail.from
    assert_match "vyznačilo odmítnutí zájemce", mail.body.encoded
  end

end
