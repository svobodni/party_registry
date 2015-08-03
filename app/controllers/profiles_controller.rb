class ProfilesController < ApplicationController

  def index
    redirect_to contacts_profiles_path
  end

  # PATCH/PUT /profile
  def update
    authorize!(:update, current_person)
    respond_to do |format|
      if current_person.update(person_params)
        current_person.events.create(default_event_params.merge({
          command: "update",
          changes: current_person.previous_changes
        }))
        format.html { redirect_to :back, notice: 'Údaje úspěšně aktualizovány.' }
      else
        format.html { render action: params[:id] }
      end
    end
  end

  def membership
    @person = current_person
  end

  def credentials
    @identities = current_person.identities
  end

  private
  def person_params
    params.require(:person).permit(:name_prefix, :name_suffix, :email, :phone, :domestic_address_street, :domestic_address_city, :domestic_address_zip, :postal_address_street, :postal_address_city, :postal_address_zip, :guest_region_id, :guest_branch_id, :username, :password, :password_confirmation)
  end

end
