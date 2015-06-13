class Backoffice::EventsController < ApplicationController

  before_action :authorize_backoffice

  def index
    @events = Event.last(20).reverse
  end

  def show
    @event = Event.find(params[:id])
  end

  private
    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
