class Backoffice::EventsController < ApplicationController

  before_action :authorize_backoffice

  def index
    @event=Event.new()
    @events = Event.all
    if params[:event]
      @event=Event.new(name: params[:event][:name], eventable_id: params[:event][:eventable_id])
      @events = @events.where(eventable_id: params[:event][:eventable_id], eventable_type: 'Person') unless params[:event][:eventable_id].blank?
      @events = @events.where(name: params[:event][:name]) unless params[:event][:name].blank?
    end
    @events = @events.order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @event = Event.find(params[:id])
  end

  private
    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
