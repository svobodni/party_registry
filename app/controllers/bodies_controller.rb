class BodiesController < ApplicationController

  before_action :authenticate_person!, except: :index

  # GET /bodies.json
  def index
    @bodies = Body.all
  end

  # GET /bodies/1.json
  def show
    @body = Body.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @body }
    end
  end
end
