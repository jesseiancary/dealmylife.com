module UserAuthentication
	protected
	 
	def is_logged_in?
		@logged_in_user = User.find(session[:user]) if session[:user]
	end
	
	def logged_in_user
		return @logged_in_user if is_logged_in?
	end
	
	def logged_in_user=(user)
		if !user.nil?
			session[:user] = user.id
			@logged_in_user = user
		end
	end
	
	# this doesn't work
	def is_logged_in_user
    unless is_logged_in? && @logged_in_user.id == params[:user_id]
      flash[:error] = "You do not have the permission to do that."
      redirect_to index_url
    end
	end

	def self.included(base)
		base.send :helper_method, :is_logged_in?, :logged_in_user
	end
	 
	def check_role(role)
		unless is_logged_in? && @logged_in_user.has_role?(role)
			flash[:error] = "You do not have the permission to do that."
			redirect_to index_url
		end
	end
	
	def check_administrator_role
		check_role('administrator')
	end
	def check_developer_role
		check_role('developer')
	end
	def check_manager_role
		check_role('manager')
	end
	def check_editor_role
		check_role('editor')
	end
	def check_partner_role
		check_role('partner')
	end
	
	def login_required
		unless is_logged_in?
			session[:requested_page] = request.url
			flash[:error] = "You must be logged in to access this page."
			redirect_to :controller => 'account', action: 'login'
		end
	end
end