class SupporterMembershipsController < ApplicationController
  def new
  end

  def create
    respond_to do |format|
      if current_person.update(person_params) && current_person.membership_requested!
        current_person.events.create(default_event_params.merge({
          command: "RequestMembership",
          name: "MembershipRequested",
          changes: current_person.previous_changes
        }))
        format.html { redirect_to membership_profiles_path, notice: 'Údaje úspěšně aktualizovány.' }
      else
        format.html { render action: :new }
      end
    end
  end

  private
  def person_params
    params.require(:person).permit(:previous_candidatures, :previous_political_parties, :amount, :agree)
  end

end
