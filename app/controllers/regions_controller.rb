class RegionsController < ApplicationController

  before_action :set_region, only: [:show, :branches, :mestske_casti, :okresy, :map, :awaiting_domestic_people, :domestic_members, :domestic_supporters, :guest_people]

  before_action :authenticate_person!, except: [:index, :show]
  before_action :authenticate_person!, only: [:show], unless: proc { params[:format]=='json' }

  # GET /regions.json
  def index
    @regions = Region.includes(:branches)
  end

  # GET /regions/1.json
  def show
    respond_to do |format|
      format.html { redirect_to region_body_path(@region) }
      format.json
    end
  end

  def map
    render 'people/map'
  end

#  def awaiting_domestic_people
#    @region = Region.find(params[:id])
#    @people = @region.awaiting_domestic_people.accessible_by(current_ability).reverse
#    respond_to do |format|
#     # format.json { render json: @people.as_json(only: [:id], methods: [:vs, :name, :'_links'], include: [ {domestic_ruian_address: {only:[:mestska_cast]}}, {domestic_branch: {only:[:name]}}] ), root: :people, each_serializer: AwaitingPersonSerializer}
#     format.json { render json: @people, root: :people, each_serializer: AwaitingPersonSerializer}
#    end
#  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find_by(id:params[:id]) || Region.find_by(slug:params[:id])
    end

end
