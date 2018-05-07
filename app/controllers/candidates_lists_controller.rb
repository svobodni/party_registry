class CandidatesListsController < ApplicationController

  before_action :authorize_backoffice

  def index
  end

  def new
    @candidates_list = CandidatesListFile.new
  end

  def preview
    candidates_list_file = CandidatesListFile.create(params.require(:candidates_list_file).permit(:sheet))
    @candidates_list = CandidatesList.load_from_xlsx(candidates_list_file)
  end

  def index
    @candidates_lists = CandidatesList.all
  end

  def show
    @candidates_list = CandidatesList.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CandidatesListPdf.new(@candidates_list)
        send_data pdf.render,
                  filename: "kandidatni_listina.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def declaration
    candidates_list = CandidatesList.find(params[:candidates_list_id])
    candidate = candidates_list.kandidati.detect{|k| k[:poradi]==params[:id].to_i }
    respond_to do |format|
      format.html
      format.pdf do
        pdf = DeclarationPdf.new(candidate, candidates_list)
        send_data pdf.render,
                  filename: "prohlaseni_kandidata.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def create
    respond_to do |format|
      Event.create(default_event_params.merge({
        command: "SaveCandidatesList",
        name: "CandidatesListSaved",
        params: JSON.load(Base64.decode64(params[:candidates_list]))
        # aggregate_type: "CandidatesList",
        # aggregate_id: SecureRandom.uuid
      }))
      format.html { redirect_to :new_candidates_list, notice: 'Kandidátní listina byla úspěšně uložena.' }
    end
  end

  private
    def authorize_backoffice
      authorize!(:backoffice, :all)
    end
end
