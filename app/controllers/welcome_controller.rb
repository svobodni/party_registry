class WelcomeController < ApplicationController

  before_action :authenticate_person!, except: :index

  # GET /
  def index
  	@country = Country.first
  end

end
