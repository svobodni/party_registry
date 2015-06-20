class EventProcessor

  attr_accessor :event

  def initialize(event)
    @event=event
  end

  def process
    EventHandler.new(event).handle
  end

  def self.process(events=[])
    [events].flatten.collect{|event|
      EventProcessor.new(event).process
    }
  end
end
