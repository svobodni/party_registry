class ProfilePicturesController < ApplicationController
  def create
    @profile_picture = @current_person.profile_pictures.build(profile_picture_params)

    respond_to do |format|
      if @profile_picture.save
        @profile_picture.events.create(default_event_params.merge({
          command: "SavePicture",
          name: "PictureSaved",
          changes: @profile_picture.previous_changes
        }))
        format.html { redirect_to personal_profiles_path, notice: 'Profilový obrázek byl úspěšně uložen.' }
        format.json { render action: 'show', status: :created, location: @profile_picture }
      else
        format.html { render action: 'new' }
        format.json { render json: @profile_picture.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # # Use callbacks to share common setup or constraints between actions.
    # def set_contact
    #   @contact = Contact.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_picture_params
      params.require(:profile_picture).permit(:photo)
    end

end
