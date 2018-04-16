class Notifier
  # novy radny clen
  def self.new_regular_member(person)
    MemberNotifications.regular(person).deliver
    PresidiumNotifications.new_regular_member(person).deliver
    #CoordinatorNotifications.new_regular_member(person).deliver if person.domestic_branch
  end

  # novy zaplaceny priznivce
  def self.new_regular_supporter(person)
    SupporterNotifications.supporter_paid(person).deliver
    PresidiumNotifications.new_regular_supporter(person).deliver
  end
end
