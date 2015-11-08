class Backoffice::PeopleController < ApplicationController

  before_action :set_person, only: [:edit, :update, :destroy, :paid]
  before_action :authorize_backoffice

  autocomplete :person, :email, :display_value => :email_name_id_region, :extra_data => [:name_prefix, :first_name, :last_name, :name_suffix, :domestic_region_id, :status]

  autocomplete :person, :id, :display_value => :name_id_region, :extra_data => [:name_prefix, :first_name, :last_name, :name_suffix, :domestic_region_id, :status, :email]

  def autocomplete_person_phone
    term = params[:term]
    people = Person.where("replace(phone, ' ', '') LIKE ?", "%#{term}%").includes(:domestic_region).order(:last_name, :first_name).limit(20).all
    render :json => people.map { |person| {:id => person.id, :label => person.phone_name_region}}, :root => false
  end

  def autocomplete_person_name
    term = params[:term]
    name_parts = term.split(' ',2)
    name_parts = name_parts.collect{|part| "%#{part}%"}
    people = (if name_parts[1].blank?
      people = Person.where('first_name LIKE ? OR last_name LIKE ?', name_parts[0], name_parts[0])
    else
      people = Person.where('(first_name LIKE ? and last_name LIKE ?) OR (first_name LIKE ? and last_name LIKE ?)', name_parts[0], name_parts[1], name_parts[1], name_parts[0])
    end).includes(:domestic_region).order(:last_name, :first_name).limit(20).all
    render :json => people.map { |person| {:id => person.id, :label => person.name_id_region_status}}, :root => false
  end

  # GET /people
  # GET /people.json
  def index
  end

  def with_unknown_address
    @people = Person.includes([:domestic_ruian_address]).select{|p| p.domestic_ruian_address.nil?}.reject{|p| p.status=="registered"}
  end

  def without_signed_application
    @people = Person.includes([:domestic_region, :signed_application]).select{|p| p.is_awaiting_membership?}.select{|p| p.signed_application.blank?}
  end

  def members_without_signed_application
    @people = Person.includes([:domestic_region, :signed_application]).regular_members.order("domestic_region_id ").select{|p| p.signed_application.blank?}
  end

  def with_bad_region
    @people = Person.includes([:domestic_ruian_address, :domestic_region]).reject{|p| p.domestic_ruian_address.nil?}.select{|p| p.domestic_ruian_address.kraj_id!=p.domestic_region.ruian_vusc_id}
  end

  def new_registrations
    @people = Person.order(id: :desc).limit(50)
  end

  # GET /people/1
  # GET /people/1.json
  def show
    id = params[:id]
    id = id[1..4] if id.length==5 && (id[0]=="1" || id[0]=="5")
    @person = Person.find_by_id(id)
    redirect_to backoffice_people_path, notice: "Osoba #{params[:id]} nenalezena" unless @person
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
        @person.events.create(default_event_params.merge({
          command: "update",
          changes: @person.previous_changes
        }))
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
    @person.paid_till="2016-12-31"
    @person.paid!
    respond_to do |format|
      @person.events.create(default_event_params.merge({
        command: "paid",
        changes: @person.previous_changes
      }))
      format.html { redirect_to :back, notice: 'Úhrada byla úspěšně vyznačena.' }
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    previous_data = {
      person_name: @person.name,
      status: @person.status,
      domestic_region_id: @person.domestic_region_id,
      domestic_branch_id: @person.domestic_branch_id
    }
    @person.destroy
    respond_to do |format|
      Event.create(default_event_params.merge({
        command: "delete",
        eventable_id: params[:id],
        eventable_type: "Person",
        previous_data: previous_data
      }))
      format.html { redirect_to backoffice_people_path, notice: 'Person was successfully destroyed.' }
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
      params.require(:person).permit(:domestic_address_ruian_id, :first_name, :last_name, :email, :name_prefix, :name_suffix, :date_of_birth, :domestic_address_street, :domestic_address_city, :domestic_address_zip, :postal_address_street, :postal_address_city, :postal_address_zip, :domestic_region_id, :status)
    end

    def authorize_backoffice
      authorize!(:backoffice, :all)
    end

end
