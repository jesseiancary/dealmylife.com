require "./lib/assets/user_authentication.rb"

class ApplicationController < ActionController::Base
  protect_from_forgery
  include UserAuthentication
  
  #location = Geocode.get_location(address)
  
  before_filter :check_authorization
  def check_authorization
    logged_in = cookies[:logged_in]
    authorization_token = cookies[:authorization_token]
    if authorization_token && logged_in && !is_logged_in?
      self.logged_in_user = User.find_by_authorization_token(authorization_token)
    end
    
    #redirect_to edit_account_path, notice: "Please set your password." if self.logged_in_user && self.logged_in_user.hashed_password.nil? && request.fullpath != edit_account_path
  
  end
  
  before_filter :set_defaults
  def set_defaults
    @layout ||= "two-col-left"
    @marquee ||= "marquee.png"
    @url = request.url
    @host = "http://" + request.host + ":" + request.port.to_s
    @default_widgets = ["usermenu"]
  end
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end
