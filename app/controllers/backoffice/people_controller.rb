class Backoffice::PeopleController < ApplicationController

  before_action :set_person, only: [:show, :edit, :update, :destroy, :paid]
  before_action :authorize_backoffice

  autocomplete :person, :email, :display_value => :email_name_id_region, :extra_data => [:name_prefix, :first_name, :last_name, :name_suffix, :domestic_region_id]
  autocomplete :person, :last_name, :display_value => :name_id_region, :extra_data => [:name_prefix, :first_name, :last_name, :name_suffix, :domestic_region_id]

  # GET /people
  # GET /people.json
  def index
  end

  def with_unknown_address
    @people = Person.includes([:domestic_ruian_address]).select{|p| p.domestic_ruian_address.nil?}.reject{|p| p.status=="registered"}
  end

  def without_signed_application
    @people = Person.includes([:domestic_region, :signed_application]).regular_members.order("domestic_region_id").select{|p| p.signed_application.blank?}
  end

  def with_bad_region
    @people = Person.includes([:domestic_ruian_address, :domestic_region]).reject{|p| p.domestic_ruian_address.nil?}.select{|p| p.domestic_ruian_address.kraj_id!=p.domestic_region.ruian_vusc_id}
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to :back, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /people/1/paid
  def paid
    @person.paid!
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Úhrada byla úspěšně vyznačena.' }
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:domestic_address_ruian_id, :first_name, :last_name, :email, :name_prefix, :name_suffix, :domestic_address_street, :domestic_address_city, :domestic_address_zip, :postal_address_street, :postal_address_city, :postal_address_zip, :domestic_region_id)
    end

    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
