class PeopleController < ApplicationController
  before_action :set_branch, only: [:show, :edit, :update, :destroy]

#  load_and_authorize_resource :branch
#  load_and_authorize_resource :person, through: :branch
  #, through: :branch, shallow: true

  # GET /people.json
  def index
    if params[:branch_id]
      render :text => @people.inspect
      #load_and_authorize_resource :branch
      #load_and_authorize_resource :people, through: :branch, shallow: true
      #@people = Branch.find(params[:branch_id]).accessible_by(current_ability).people
    else
     # @people = Person.accessible_by(current_ability)
    end
    @people = Person.all
    render json: @people
  end

  # GET /people/1.json
  def show
    render json: @person
  end

  # POST /branches
  # POST /branches.json
  def create
    @person = Person.new(person_params)

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
    respond_to do |format|
      if @person.update(person_params)
        format.json { head :no_content }
      else
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /branches/1
  # DELETE /branches/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_branch
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:first_name, :last_name)
    end
end
