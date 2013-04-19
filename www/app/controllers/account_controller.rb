class AccountController < ApplicationController
	
	def login
		@title = "Account Login"
		@layout = "one-col"
		if authorization_token = cookies[:authorization_token]
			@user = User.find_by_authorization_token( authorization_token )
			@user.remember_me = true
		end
	end

	def authenticate
		
		self.logged_in_user = User.authenticate(params[:user][:email], params[:user][:password])
		
		if is_logged_in?
				
			user = logged_in_user
			
			if params[:user][:remember_me] == "1"
				cookies[:logged_in] = { :value => true, :expires => 30.days.from_now }
				user.authorization_token = user.id
				user.save!
				cookies[:authorization_token] = { :value => user.authorization_token, :expires => 30.days.from_now }
			else
				cookies.delete(:logged_in)
				cookies.delete(:authorization_token)
			end
			
			if redirect_url = session[:requested_page]
				session[:requested_page] = nil
				redirect_to redirect_url
			else
				redirect_to index_url
			end
			
		else
			
			flash[:error] = "Email or Password was incorrect."
			redirect_to action: "login"
			
		end
		
	end

	def logout
		if request.post?
			cookies.delete(:logged_in)
			reset_session
			flash[:notice] = "You have been logged out."
		end
		redirect_to controller: "account", action: "login"
	end
	
	def reset_password
    @user = User.find_by_email params[:email]
    #respond_to do |format|
      if !@user.nil?
        UserMailer.reset_password_email(@user, @user.reset_password).deliver
        render :json => { :status => "OK", :message => "Success", :html => "<span>Your password has been successfully reset. Please check your email for instructions on how to log in.</span>" }
      else
        render :json => { :status => "ERROR", :message => "User not found.", :html => "<span>Sorry, we could not find your email address on file.</span>" }
      end
    #end
	end

end
