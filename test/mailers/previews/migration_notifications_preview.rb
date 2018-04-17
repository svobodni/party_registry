class MigrationNotificationsPreview < ActionMailer::Preview
  def older
    MigrationNotifications.older(Person.first)
  end

  def newer
    MigrationNotifications.newer(Person.first)
  end
end
