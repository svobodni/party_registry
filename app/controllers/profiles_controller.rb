class ProfilesController < ApplicationController

  def index
    redirect_to contacts_profiles_path
  end

  # PATCH/PUT /profile
  def update
    authorize!(:update, current_person)
    respond_to do |format|
      if current_person.update(person_params)
        format.html { redirect_to :back, notice: 'Údaje úspěšně aktualizovány.' }
      else
        format.html { render action: params[:id] }
      end
    end
  end

  private
  def person_params
    params.require(:person).permit(:name_prefix, :name_suffix, :date_of_birth, :domestic_address_street, :guest_region_id, :guest_branch_id)
  end

end
