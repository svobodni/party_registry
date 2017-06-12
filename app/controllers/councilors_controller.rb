class CouncilorsController < ApplicationController

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def index
    respond_to do |format|
      format.html {
        load_country
        if params[:region_id]
          @region = Region.find(params[:region_id])
          @councilors = @region.councilors
        else
          @councilors=Councilor.all
        end
      }
      format.json
    end
  end

end
