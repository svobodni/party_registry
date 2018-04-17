require 'test_helper'

class OfficeNotificationsTest < ActionMailer::TestCase
  test "membership_request_rejected" do
    mail = OfficeNotifications.membership_request_rejected
    assert_equal "Membership request rejected", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
