class EventHandler

  attr_accessor :event

  def initialize(event)
    @event=event
  end

  def handle
    puts "Handling #{event.inspect}"
    # PersonDeletedHandler
    if (event.command=="delete" && event.eventable_type=="Person")
      Presenters::NewsFeed.create(
        content: "#{ActionController::Base.helpers.t event.previous_data[:status], scope: :person_status}  #{event.previous_data[:person_name]} byl/a smazán z databáze.",
        region_id: event.previous_data[:domestic_region_id],
        branch_id: event.previous_data[:domestic_branch_id],
        event: event
      ) if event.previous_data
    elsif event.command=="CancelMembership"
      Presenters::NewsFeed.create(
        content: "#{event.eventable.name} ukončil/a členství.",
        region_id: event.eventable.domestic_region_id,
        branch_id: event.eventable.domestic_branch_id,
        event: event
      )
    elsif event.command=="CreateRole" && event.new_values[:type]=="Coordinator"
      person = Person.find(event.new_values[:person_id])
      branch = Branch.find(event.new_values[:branch_id])
      Presenters::NewsFeed.create(
        content: "#{Person.name} byl jmenován koordinátorem pobočky #{branch.name}.",
        region: branch.region,
        branch: branch,
        event: event
      ) if event.previous_data
    end
  end

end
