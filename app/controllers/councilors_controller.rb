class CouncilorsController < ApplicationController

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def index
    respond_to do |format|
      format.html {
        load_country
        @councilors=Councilor.all
      }
      format.json
    end
  end

end
