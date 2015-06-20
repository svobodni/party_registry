# -*- encoding : utf-8 -*-
class ContactsController < ApplicationController
  before_action :set_contact, only: [:edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.accessible_by(current_ability).includes(:person).references(:person)
    if params[:region_id]
      @region = Region.find(params[:region_id])
      @contacts = @contacts.where("people.domestic_region_id=? or people.guest_region_id=?", params[:region_id], params[:region_id])
    elsif params[:branch_id]
      @branch = Organization.find(params[:branch_id])
      @contacts = @contacts.where("people.domestic_branch_id=? or people.guest_branch_id=?", params[:branch_id], params[:branch_id])
    end
    @contacts = @contacts.group_by(&:contactable)
  end

  # GET /contacts/new
  def new
    @contact = @current_person.contacts.build
    authorize!(:create, @contact)
  end

  # GET /contacts/1/edit
  def edit
    authorize!(:update, @contact)
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = @current_person.contacts.build(contact_params)

    respond_to do |format|
      if @contact.save
        @contact.events.create(default_event_params.merge({
          command: "CreateContact",
          name: "ContactCreated",
          changes: @contact.previous_changes
        }))
        format.html { redirect_to contacts_profiles_path, notice: 'Kontakt byl úspěšně přidán.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    authorize!(:update, @contact)
    respond_to do |format|
      if @contact.update(contact_params)
        @contact.events.create(default_event_params.merge({
          command: "UpdateContact",
          name: "ContactUpdated",
          changes: @contact.previous_changes
        }))
        format.html { redirect_to contacts_profiles_path, notice: 'Kontakt byl úspěšně aktualizován.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    authorize!(:destroy, @contact)
    @contact.destroy
    respond_to do |format|
      Event.create(default_event_params.merge({
        command: "DeleteContact",
        name: "ContactDeleted",
        eventable_id: params[:id],
        eventable_type: "Contact"
      }))
      format.html { redirect_to contacts_profiles_path, notice: 'Kontakt byl úspěšně zrušen.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:contact_type, :contact, :privacy)
    end
end
