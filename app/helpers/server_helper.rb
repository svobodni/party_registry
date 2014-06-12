
module ServerHelper

  def url_for_user
    url_for :controller => 'server', :action => 'user_page',:username=>current_person.username
  end

end

