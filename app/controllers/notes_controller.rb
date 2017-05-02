class NotesController < ApplicationController
  # GET /notes/new
  def new
    @note = Note.new
    @note.noteable = Person.find(params[:person_id])
  end

  # POST /notes
  # POST /notes.json
  def create
    @person = Person.find(params[:person_id])
    @note = @person.notes.new(note_params)
    @note.creator = current_person

    respond_to do |format|
      if @note.save
        format.html { redirect_to @person, notice: 'Poznámka byla úspešně uložena.' }
        format.json { render json: @note, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:content)
    end
end
