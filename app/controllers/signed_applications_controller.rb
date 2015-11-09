# -*- encoding : utf-8 -*-
class SignedApplicationsController < ApplicationController
  # GET /signed_applications/new
  def new
    @signed_application = SignedApplication.new(person_id: params[:person_id])
    authorize!(:upload, @signed_application)
  end

  # POST /signed_applications
  # POST /signed_applications.json
  def create
    @signed_application = SignedApplication.new(signed_application_params)
    authorize!(:upload, @signed_application)

    respond_to do |format|
      if @signed_application.save
        Person.find(signed_application_params[:person_id]).events.create(default_event_params.merge({
          command: "ReceiveApplication",
          name: "ApplicationReceived"
        }))
        format.html { redirect_to new_signed_application_path, notice: 'Přihláška byla úspěšně uložena.' }
        format.json { render action: 'show', status: :created, location: @signed_application }
      else
        format.html { render action: 'new' }
        format.json { render json: @signed_application.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def signed_application_params
      params.require(:signed_application).permit(:person_id, :scan)
    end
end
