class FinanceApiController < ApplicationController

  before_filter :authenticate, :set_person

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def payments
    respond_to do |format|
      format.json
    end
  end

  def supporter_paid
    @person.paid_till="2019-12-31"
    @person.supporter_paid!
    respond_to do |format|
      @person.events.create(default_api_event_params.merge({
        command: "AcceptPayment",
        name: "PaymentAccepted",
        changes: @person.previous_changes
      }))
      format.json { head :no_content }
    end
  end

  def member_paid
    @person.paid_till="2019-12-31"
    @person.member_paid!
    respond_to do |format|
      @person.events.create(default_api_event_params.merge({
        command: "AcceptPayment",
        name: "PaymentAccepted",
        changes: @person.previous_changes
      }))
      format.json { head :no_content }
    end
  end

  private
  def default_api_event_params
    {
    params: params,
    controller_path: controller_path,
    action_name: action_name,
    remote_ip: request.remote_ip,
    referer: request.referer,
    api_name: 'finance'
    }
  end

  def authenticate
    authenticate_or_request_with_http_basic('Finance API') do |username, password|
      username == 'finance' && password == configatron.finance.password
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    vs = params[:id].to_s
    # docasna kompatibilita se starym VS
    vs = vs[1..5] if vs.length==5 && vs[0].match(/1|5/)
    @person = Person.find(vs[1..5])
  end

end
