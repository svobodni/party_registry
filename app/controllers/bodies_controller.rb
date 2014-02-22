class BodiesController < ApplicationController
  # GET /bodies.json
  def index
    @bodies = Body.all
    render json: @bodies
  end

  # GET /bodies/1.json
  def show
    @body = Body.find(params[:id])
    render json: @body
  end
end
