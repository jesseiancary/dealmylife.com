class ProfilesController < ApplicationController
	before_filter :login_required
	
	# GET /profiles
	# GET /profiles.json
	def index
		@profiles = Profile.all
		@title = "Member Profiles"

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @profiles }
		end
	end

  # GET /profile
  # GET /profile.json
  def show
    @user = logged_in_user
    @profile = @user.profile ||= Profile.new
    @title = @user.email
    
    respond_to do |format|
      format.html { render action: "show" }
      format.json { render json: @profile }
    end
  end

	# GET /profile/edit
	def edit
		@user = logged_in_user
		@profile = @user.profile ||= Profile.new
		@title = @user.email + ": Update Profile"
	end

	# PUT /profiles/1
	# PUT /profiles/1.json
	def update
		@profile = Profile.find(params[:id])

		respond_to do |format|
			if @profile.update_attributes(params[:profile])
				format.html { redirect_to show_profile_url, notice: 'Profile was successfully updated.' }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @profile.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /profiles/1
	# DELETE /profiles/1.json
	def destroy
		@profile = Profile.find(params[:id])
		@profile.destroy

		respond_to do |format|
			format.html { redirect_to profiles_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /profiles/:id/enable
	# PUT /profiles/:id/enable.json
	def enable
		@profile = Profile.find(params[:id])
		
		respond_to do |format|
			if @profile.update_attribute(:enabled, true)
				format.html { redirect_to profiles_url, notice: "Profile Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to profiles_url, notice: "There was an error enabling this Profile" }
				format.json	{ render json: @profile.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /profiles/:id/disable
	# PUT /profiles/:id/disable.json
	def disable
		@profile = Profile.find(params[:id])
		
		respond_to do |format|
			if @profile.update_attribute(:enabled, false)
				format.html { redirect_to profiles_url, notice: "Profile Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to profiles_url, notice: "There was an error disabling this Profile" }
				format.json	{ render json: @profile.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
end
