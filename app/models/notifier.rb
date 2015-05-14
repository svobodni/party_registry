class Notifier
  # novy radny clen
  def self.new_regular_member(person)
    MemberNotifications.regular(person).deliver
    PresidiumNotifications.new_regular_member(person).deliver
    #CoordinatorNotifications.new_regular_member(person).deliver if person.domestic_branch
  end
end
