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
        @councilors=@councilors.where("since>2016-01-01")
      }
      format.json {
        @regional_councilors = Councilor.regional.group_by{|c| c.council_name}
        @municipal_councilors = Councilor.municipal.where("since>'2018-01-01'").
group_by{|c| [c.council_name, c.voting_party]}
      }
    end
  end

end
