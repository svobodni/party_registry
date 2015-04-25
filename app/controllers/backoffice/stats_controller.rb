class Backoffice::StatsController < ApplicationController

  before_action :authorize_backoffice

  def index
    @stats = {}
    @stats[:totals]={}
    @stats[:totals][:regular_members]=Person.regular_members.count
    @stats[:totals][:regular_supporters]=Person.regular_supporters.count
    @stats[:regions]=Region.all.collect{|region|
      {
        id: region.id,
        name: region.name,
        regular_members: Person.regular_members.where(domestic_region_id: region.id).count,
        regular_supporters: Person.regular_supporters.where(domestic_region_id: region.id).count,
        awaiting_people: region.domestic_people.select{|p| p.is_awaiting_membership?}.size
      }
    }
  end

  private
    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
