class MemberNotificationsPreview < ActionMailer::Preview
  def paid
    MemberNotifications.paid(Person.first)
  end

  def registered
    MemberNotifications.registered(Person.first)
  end

  def regular
    MemberNotifications.regular(Person.first)
  end

  def rejected
    MemberNotifications.rejected(Person.first)
  end

  def renewed
    MemberNotifications.renewed(Person.first)
  end

  def supporter_membership_requested
    MemberNotifications.supporter_membership_requested(Person.first)
  end

  def supporter_paid
    MemberNotifications.supporter_paid(Person.first)
  end

  def supporter_payment_pending
    MemberNotifications.supporter_payment_pending(Person.first)
  end

  def supporter_regular
    MemberNotifications.supporter_regular(Person.first)
  end

  def supporter_rejected
    MemberNotifications.supporter_rejected(Person.first)
  end

end
