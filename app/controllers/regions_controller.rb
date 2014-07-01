class RegionsController < ApplicationController

  before_action :authenticate_person!, except: [:index, :show]

  # GET /regions.json
  def index
    @regions = Region.includes(:branches)
  end

  # GET /regions/1.json
  def show
    @region = Region.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end
end
