class Presenters::NewsFeed < ActiveRecord::Base

  belongs_to :event
  belongs_to :person
  belongs_to :branch
  belongs_to :region

  def self.rebuild
    self.delete_all
    EventProcessor.process(Event.all)
  end

  before_create :set_date

  def set_date
    self.created_at=event.created_at
  end

end
