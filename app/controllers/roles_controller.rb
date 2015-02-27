class RolesController < ApplicationController

  autocomplete :person, :last_name, :display_value => :name_id_region, :extra_data => [:name_prefix, :first_name, :last_name, :name_suffix, :domestic_region_id]

  # We want autocomplete to search within multiple fields, so override method
  # Note that first_name and last_name must be included in the SELECT list
  # so Contact.display_name can use them to build the name returned for
  # the autocomplete.
  def get_autocomplete_items(parameters)
    items = Person.accessible_by(current_ability, :read).
    select("first_name, last_name, id, name_prefix, name_suffix, domestic_region_id").
    #where(["LOWER(last_name || ', ' || first_name) " +
    #  "LIKE LOWER(?)", "%#{parameters[:term]}%"]).
    where("last_name LIKE :query", query: "%#{parameters[:term]}%").
      order("last_name, first_name")
  end

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.current.includes(:person, :body, :branch)
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # POST /roles
  # POST /roles.json
  def create
    if params[:role].try(:type)=="Coordinator"
      @role = Coordinator.new(params.require(:role).permit(:person_id, :branch_id, :since))
      @role.till = "2099-01-01"
    else
      @role = Role.new(params.require(:role).permit(:person_id, :body_id, :since, :till, :type))
    end
    authorize!(:create, @role)
    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_url, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: 'new' }
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
        format.html { redirect_to roles_url }
        format.json { head :no_content }
      end
    end
  end

end
