class EventsController < ApplicationController

  #before_action :set_region, only: [:show, :branches, :mestske_casti, :okresy, :map, :awaiting_domestic_people, :domestic_members, :domestic_supporters, :guest_people]

  before_action :authenticate_person! #, except: [:index, :show]
  #before_action :authenticate_person!, only: [:show], unless: proc { params[:format]=='json' }

  def index
    @event=Event.new()
    @events = Event.accessible_by(current_ability)
    if params[:event]
      @event=Event.new(name: params[:event][:name], eventable_id: params[:event][:eventable_id])
      @events = @events.where(eventable_id: params[:event][:eventable_id], eventable_type: 'Person') unless params[:event][:eventable_id].blank?
      @events = @events.where(name: params[:event][:name]) unless params[:event][:name].blank?
    end
    @events = @events.order('created_at DESC').paginate(:page => params[:page], :per_page => 500)
    @event_groups = @events.group_by{|e| e.created_at.to_date}
  end

end
