class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :application, :signed_application]

  # GET /people.json
  def index
    if params[:branch_id]
      @people = Person.accessible_by(current_ability).where("domestic_branch_id=? or guest_branch_id=?", params[:branch_id], params[:branch_id])
    elsif params[:region_id]
      @people = Person.accessible_by(current_ability).where("domestic_region_id=? or guest_region_id=?", params[:region_id], params[:region_id])
    else
      @people = Person.accessible_by(current_ability)
    end
    respond_to do |format|
      format.xls
      format.json
    end

  end

  # GET /people/1.json
  def show
    authorize!(:show, @person)
    respond_to do |format|
      format.html
      format.json { render json: @person }
    end
  end

  # GET /people/profile.json
  def profile
    @person = current_user
    authorize!(:show, @person)
    respond_to do |format|
      format.json
      format.html
    end
  end

  # POST /branches
  # POST /branches.json
  def create
    @person = Person.new(person_params)
    authorize!(:create, @person)
    respond_to do |format|
      if @person.save
        format.json { render json: @person, status: :created, location: @person }
      else
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1.json
  def update
    authorize!(:update, @person)
    respond_to do |format|
      if @person.update(person_params)
        format.json { head :no_content }
      else
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    authorize!(:destroy, @person)
    @person.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def application
  end

  def signed_application
    authorize!(:show, @person)
    send_file  @person.signed_application.scan.path, type: @person.signed_application.scan_content_type, disposition: :inline
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :email, :password)
    end
end
