class FinanceApiController < ApplicationController

  before_filter :authenticate, :set_person

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def payments
    respond_to do |format|
      format.json
    end
  end

  def paid
    @person.paid_till="2017-12-31"
    @person.paid!
    respond_to do |format|
      @person.events.create(default_event_params.merge({
        command: "AcceptPayment",
        name: "PaymentAccepted",
        changes: @person.previous_changes
      }))
      format.json { head :no_content }
    end
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic('Finance API') do |username, password|
      username == 'finance' && password == configatron.finance.password
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    vs = params[:id].to_s
    # VS musí mít 5 znaků
    raise ActiveRecord::RecordNotFound unless vs.length==5
    # VS musí začínat jedničkou nebo pětkou
    raise ActiveRecord::RecordNotFound unless vs[0].match(/1|5/)
    @person = Person.find(vs[1..5])
  end

end
