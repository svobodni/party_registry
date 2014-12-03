class RolesController < ApplicationController

#  before_action :authenticate_person!, except: :payments

  # POST /roles.json
  def create
    @role = Role.new(role_params)
    authorize!(:create, @role)
    respond_to do |format|
      if @role.save
        format.json { render json: @role, status: :created, location: @role }
      else
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role = Role.find(params[:id])
    authorize!(:destroy, @role)
    if params[:role] && params[:role][:till]
      @role.update_attribute :till, params[:role][:till]
      respond_to do |format|
        format.html { redirect_to roles_path }
        format.json { head :no_content }
      end
    end
  end

  def index
    @roles = Role.current.includes(:person, :body, :branch)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:role).permit(:person_id, :body_id, :branch_id, :since, :till)
    end

end