class MembershipRequest < ActiveRecord::Base
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

end
