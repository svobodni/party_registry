class SupporterNotificationsPreview < ActionMailer::Preview
  def registered
    SupporterNotifications.registered(Person.first)
  end

  def regular
    SupporterNotifications.regular(Person.first)
  end

  def renewed
    SupporterNotifications.renewed(Person.first)
  end
end
