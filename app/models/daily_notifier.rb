class DailyNotifier

  def self.notify_regional_presidiums
    data = Event.where("created_at >= ?", Time.now - 1.day).where(eventable_type: "Person", command: "delete").group_by{|a| a.previous_data["domestic_region_id"]}
    data.each{|region_id, events|
      region = Region.find(region_id)
      PresidiumNotifications.daily_event_notifier(region, events).deliver
    }
  end

  def self.notify_branch_coordinators
    data = Event.where("created_at >= ?", Time.now - 1.day).where(eventable_type: "Person", command: "delete").group_by{|a| a.previous_data["domestic_branch_id"]}
    data.each{|branch_id, events|
      if branch_id
        branch = Branch.find(branch_id)
        CoordinatorNotifications.daily_event_notifier(branch, events).deliver
      end
    }
  end

end
