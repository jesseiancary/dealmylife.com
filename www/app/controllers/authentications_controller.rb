class AuthenticationsController < ApplicationController
  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = logged_in_user.authentications if logged_in_user
  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_provider_uid(omniauth["provider"], omniauth["uid"])
    if authentication
      self.logged_in_user = authentication.user
      flash[:notice] = "Login Successful."
    elsif logged_in_user
      logged_in_user.authentications.create!(:provider => omniauth["provider"], :provider_uid => omniauth["uid"])
      flash[:notice] = "Authentication Successful."
    elsif User.find_by_email omniauth["info"]["email"]
      self.logged_in_user = User.find_by_email omniauth["info"]["email"]
      logged_in_user.authentications.create!(:provider => omniauth["provider"], :provider_uid => omniauth["uid"])
      flash[:notice] = "User Found: Authentication Successful."
    else
      user = User.new(:email => omniauth["info"]["email"])
      user.authentications.build(:provider => omniauth["provider"], :provider_uid => omniauth["uid"])
      user.profile = Profile.new(:first_name => omniauth["info"]["first_name"], :last_name => omniauth["info"]["last_name"])
      Category.all.each do | category |
        user.categories << category if !(user.has_category?(category.id))
      end
      user.save!
      self.logged_in_user = user
      flash[:notice] = "Welcome to DealMyLife.com"
    end
    respond_to do |format|
      format.html { redirect_to index_url }
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = logged_in_user.authentications.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json  { head :ok }
    end
  end
end
