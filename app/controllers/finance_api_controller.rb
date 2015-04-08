class FinanceApiController < ApplicationController

  before_filter :authenticate

  skip_before_action :authenticate_person!
  skip_before_action :load_country

  def payments
    vs = params[:id].to_s
    # VS musí mít 5 znaků
    raise ActiveRecord::RecordNotFound unless vs.length==5
    # VS musí začínat jedničkou nebo pětkou
    raise ActiveRecord::RecordNotFound unless vs[0].match(/1|5/)
    @person = Person.find(vs[1..5])
    respond_to do |format|
      format.json
    end
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic('Finance API') do |username, password|
      username == 'finance' && password == configatron.finance.password
    end
  end

end
