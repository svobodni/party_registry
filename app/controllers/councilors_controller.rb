class CouncilorsController < ApplicationController

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def index
  end

end
