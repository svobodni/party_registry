class RegionsController < ApplicationController
  # GET /regions.json
  def index
    @regions = Region.includes(:branches)
    render json: @regions
  end

  # GET /regions/1.json
  def show
    @region = Region.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @region }
    end
  end
end
