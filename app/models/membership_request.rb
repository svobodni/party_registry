class MembershipRequest < ApplicationRecord
  belongs_to :person

  def application_received?
    !application_received_on.blank?
  end

  def approved?
    !approved_on.blank?
  end

  def paid?
    !paid_on.blank?
  end

  def last_changed_on
    [membership_requested_on,application_received_on,approved_on,paid_on].compact.max
  end
end
