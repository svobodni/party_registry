class Backoffice::EventsController < ApplicationController

  before_action :authorize_backoffice

  def index
    @event=Event.new()
    @events = Event.all
    if params[:event]
      @event=Event.new(command: params[:event][:command], eventable_id: params[:event][:eventable_id])
      @events = @events.where(eventable_id: params[:event][:eventable_id], eventable_type: 'Person') unless params[:event][:eventable_id].blank?
      @events = @events.where(command: params[:event][:command]) unless params[:event][:command].blank?
    end
    @events = @events.last(20).reverse
  end

  def show
    @event = Event.find(params[:id])
  end

  private
    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
