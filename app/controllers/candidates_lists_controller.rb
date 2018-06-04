class CandidatesListsController < ApplicationController

  def index
  end

  def new
    authorize!(:upload, CandidatesList)
    @candidates_list = CandidatesListFile.new
  end

  def preview
    authorize!(:upload, CandidatesList)
    candidates_list_file = CandidatesListFile.create(params.require(:candidates_list_file).permit(:sheet))
    @candidates_list = CandidatesList.load_from_xlsx(candidates_list_file)
  end

  def index
    authorize!(:read, CandidatesList)
    @candidates_lists = CandidatesList.all
  end

  def show
    authorize!(:read, CandidatesList)
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
    authorize!(:generate_declaration, CandidatesList)
    candidates_list = CandidatesList.find(params[:candidates_list_id])
    candidate = candidates_list.kandidati[params[:id].to_i]
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

  def declarations
    authorize!(:generate_declaration, CandidatesList)
    candidates_list = CandidatesList.find(params[:id])
    respond_to do |format|
      format.html
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          candidates_list["kandidati"].each do |candidate|
            zos.put_next_entry "prohlaseni-#{candidates_list['kod_zastupitelstva']}-#{candidate['poradi']}.pdf"
            zos.print DeclarationPdf.new(candidate, candidates_list).render
          end
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "prohlaseni-#{candidates_list["kod_zastupitelstva"]}.zip"
      end
    end
  end

  def create
    authorize!(:upload, CandidatesList)
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
