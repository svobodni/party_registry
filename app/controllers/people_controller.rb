class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy, :application, :signed_application, :private, :photo, :cv, :approve, :cancel_membership]

  before_action :authenticate_person!, except: [:payments, :private, :photo, :cv]

  # GET /people.json
  def index
    if params[:branch_id]
      @people = Person.accessible_by(current_ability).where("domestic_branch_id=? or guest_branch_id=?", params[:branch_id], params[:branch_id])
    elsif params[:region_id]
      @people = Person.accessible_by(current_ability).where("domestic_region_id=? or guest_region_id=?", params[:region_id], params[:region_id])
    else
      @people = Person.accessible_by(current_ability)
    end
    @people = @people.includes([:domestic_region, :domestic_branch, :domestic_ruian_address])
    respond_to do |format|
      format.xls
      format.json
    end
  end

  def beran_export
    @people = Person.accessible_by(current_ability).where(status: (Person.regular_supporter_states+["regular_member"]), snail_newsletter: true)
    respond_to do |format|
      format.xls
      format.csv {
        render text: (CSV.generate do |csv|
          column_names=[:first_name, :last_name, :street, :city, :zip]
          csv << column_names
          @people.each do |person|
            if person.postal_address_street.blank?
              column_names=['first_name', 'last_name', 'domestic_address_street', 'domestic_address_city', 'domestic_address_zip']
            else
              column_names=['first_name', 'last_name', 'postal_address_street', 'postal_address_city', 'postal_address_zip']
            end
            csv << person.attributes.values_at(*column_names)
            end
        end)
      }
    end
  end

  # GET /people/1.json
  def show
    #authorize!(:show, @person)
    if @person.contacts.accessible_by(current_ability).empty? && !can?(:show, @person)
      authorize!(:show, @person)
    else
      respond_to do |format|
        format.html
        format.json {render template: "people/profile"}
      end
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

  # GET /people/dashboard.json
  def dashboard
    @person = current_user
    unless @person.is_regular?
      redirect_to membership_profiles_path
    else
      authorize!(:show, @person)
      respond_to do |format|
        format.html # {render layout: "dashboard"}
      end
    end
  end

  # POST /people/123/approve
  def approve
    authorize!(:approve, @person)
    @person.presidium_accepted!
    @person.events.create(default_event_params.merge({
      command: "AcceptPerson",
      name: "PersonAccepted",
      changes: @person.previous_changes
    }))
    respond_to do |format|
      if @person.errors.empty?
        format.html { redirect_to :back, notice: 'Členství bylo úspěšně schváleno.'}
      else
        format.html { redirect_to :back, alert: 'Změnu se nepodařilo uložit: '+@person.errors.full_messages.join("<br/>") }
      end
    end
  end

  # POST /people/123/approve
  def cancel_membership
    authorize!(:cancel_membership, @person)
    @person.cancel_request!
    respond_to do |format|
      if @person.errors.empty?
        @person.events.create(default_event_params.merge({
          command: "CancelMembership",
          name: "MembershipCancelled",
          changes: @person.previous_changes
        }))
        format.html { redirect_to :back, notice: 'Členství bylo úspěšně zrušeno.'}
      else
        format.html { redirect_to :back, alert: 'Změnu se nepodařilo uložit: '+@person.errors.full_messages.join("<br/>") }
      end
    end
  end

  def private
    authorize!(:show, @person)
    respond_to do |format|
      format.json
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

    previous_data = {
      person_name: @person.name,
      status: @person.status,
      domestic_region_id: @person.domestic_region_id,
      domestic_branch_id: @person.domestic_branch_id
    }

    @person.destroy
    respond_to do |format|
      Event.create(default_event_params.merge({
        command: "DeletePerson",
        name: "PersonDeleted",
        eventable_id: params[:id],
        eventable_type: "Person",
        previous_data: previous_data
      }))
      format.html { redirect_to contacts_profiles_path, notice: 'Registrace osoby byla úspěšně zrušena.' }
      format.json { head :no_content }
    end
  end

  def application
    authorize!(:application, @person)
  end

  def signed_application
    authorize!(:show, @person)
    send_file  @person.signed_application.scan.path, type: @person.signed_application.scan_content_type, disposition: :inline
  end

  def photo
    authenticate_person! if @person.roles.empty?
    send_data HTTParty.get(@person.files_photo_url).body, filename: "#{@person.id}.png", type: 'image/png', disposition: :inline
  end

  def cv
    authenticate_person! if @person.roles.empty?
    if @person.cv.path
      # lokalne ulozeny zivotopis
      send_file  @person.cv.path, type: @person.cv.content_type, disposition: :inline
    else
      # zkusime zivotopis z files
      response = HTTParty.get(@person.files_cv_url)
      if response.code == 200
        send_data response.body, filename: "#{@person.id}.pdf", type: 'application/pdf', disposition: :inline
      else
        render text: 'Kandidát dosud nenahrál ke svému profilu žádný životopis', status: '404', content_type: "text/html"
      end
    end
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
