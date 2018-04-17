# Preview all emails at http://localhost:3000/rails/mailers/office_notifications
class OfficeNotificationsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/office_notifications/membership_request_rejected
  def membership_request_rejected
    OfficeNotifications.membership_request_rejected
  end

end
