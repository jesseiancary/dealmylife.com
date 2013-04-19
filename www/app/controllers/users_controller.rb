class UsersController < ApplicationController
	before_filter :check_administrator_role, :only => [ :index, :destroy, :enable ]
	before_filter :login_required, :except => [ :new, :create ]
	
	# GET /users
	# GET /users.json
	def index
		@users = User.all

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @users }
		end
	end

	# GET /users/1
	# GET /users/1.json
=begin
	def show
		@user = User.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @user }
		end
	end
=end

	# GET /users/new
	# GET /users/new.json
	def new
		@user = User.new
		@categories = Category.all
    @layout = "one-col"
    @marquee = "marquee_sm.png"

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @user }
		end
	end

	# GET /users/1/edit or /users/:userid/edit
	def edit
		if params[:id]
			@user = User.find(params[:id])
		else
			@user = logged_in_user
		end
	end

	# POST /users
	# POST /users.json
	def create
		@user = User.new(params[:user])

		respond_to do |format|
			if @user.save
        #AccountMailer.welcome_email(@user).deliver
			  @user.profile ||= Profile.new
			  @user.profile.gender = params[:gender]
			  
			  UserMailer.welcome_email(@user).deliver
		    
		    if params[:a] && !params[:a].empty?
          address = Address.new
          address.geocode params[:a]
          profile_address = ProfileAddress.new :profile => @user.profile, :address => address, :label => "Default Address", :default => @user.profile.profile_addresses.count.to_i.zero?
          address.destroy unless !address.geocode.nil? and address.save and profile_address.save
        end
        
        if params[:categories]
  			  params[:categories].each do | name, id |
            if @category = Category.find_by_id(id)
              @user.categories << @category if !(@user.has_category?(@category.id))
            end
  			  end
  			else
          Category.all.each do | category |
            @user.categories << category if !(@user.has_category?(category.id))
          end
  			end
			  
			  if logged_in_user
          format.html { redirect_to users_url, notice: "Congratulations! User Account has been created." }
				  format.json	{ render json: @user, status: :created, :location => @user }
			  else
          self.logged_in_user = User.authenticate(params[:user][:email], params[:user][:password])
				  format.html { redirect_to index_url, notice: "Congratulations! Your User Account has been created. Welcome to DealMyLife.com!" }
			  end
			else
				format.html { render action: "new" }
				format.json	{ render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.json
	def update
		@user = User.find(params[:id])

		respond_to do |format|
			if @user.update_attributes(params[:user])
				#format.html { post_to :controller => "account", action: "logout", notice: "User Account has been updated." }
        format.html { redirect_to users_url, notice: "Password has been successfully updated." }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		@user = User.find(params[:id])
		@user.destroy

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /users/:id/enable
	# PUT /users/:id/enable.json
	def enable
		@user = User.find(params[:id])
		
		respond_to do |format|
			if @user.update_attribute(:enabled, true)
				format.html { redirect_to users_url, notice: "User Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to users_url, notice: "There was an error enabling this User" }
				format.json	{ render json: @user.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /users/:id/disable
	# PUT /users/:id/disable.json
	def disable
		@user = User.find(params[:id])
		
		respond_to do |format|
			if @user.update_attribute(:enabled, false)
				format.html { redirect_to users_url, notice: "User Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to users_url, notice: "There was an error disabling this User" }
				format.json	{ render json: @user.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
end
