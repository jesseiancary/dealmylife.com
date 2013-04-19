class ClicksController < ApplicationController

  # GET /clicks/new
  # GET /clicks/new.json
  def new
    @click = Click.new
    
    @click.user_id = logged_in_user.id if logged_in_user
    @click.partner_id = params[:partner]
    @click.ip_address = request.remote_ip
    @click.url = params[:redirect]
    
    @click.save

    respond_to do |format|
      format.html { redirect_to params[:redirect] }
      format.json { render json: @click }
    end
  end
  
end
