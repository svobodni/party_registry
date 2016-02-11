class Backoffice::AttendanceListsController < ApplicationController

  before_action :authorize_backoffice_read

  def new
  end

  def create
    date = params[:attendance_list]["date(1i)"] + '-' +
    params[:attendance_list]["date(2i)"] + '-' +
    params[:attendance_list]["date(3i)"]
    redirect_to backoffice_attendance_list_path(date, format: :pdf)
  end

  def show
    @date = params[:id].to_date
    @roles = Body.find(5).roles
    @members_count = @roles.size
    @members_majority = (@members_count/2.to_f).ceil
    @members_max_count = 49
  end

  private
  def authorize_backoffice_read
    authorize!(:backoffice, :read)
  end

end
