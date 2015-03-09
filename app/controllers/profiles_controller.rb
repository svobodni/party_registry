class ProfilesController < ApplicationController

  include Wicked::Wizard

  steps :personal, :credentials, :contacts, :addresses, :guesting

  def show
    render_wizard
  end

  # PATCH/PUT /profile
  def update
    authorize!(:update, current_person)
    current_person.update(person_params)
    render_wizard current_person
  end

  private
  def person_params
    params.require(:person).permit(:name_prefix, :name_suffix, :date_of_birth)
  end

end
