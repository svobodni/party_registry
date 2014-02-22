class RegionsController < ApplicationController
  # GET /regions.json
  def index
    @regions = Region.includes(:branches).all
    render json: @regions
  end

  # GET /regions/1.json
  def show
    @region = Region.find(params[:id])
    render json: @region
  end
end
