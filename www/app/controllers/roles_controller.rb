class RolesController < ApplicationController
	before_filter :check_administrator_role
	before_filter :login_required

	def index
		@all_roles = Role.all
		@user = User.find(params[:user_id])

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @all_roles }
		end
	end
	
	def update
		@role = Role.find(params[:id])
		@user = User.find(params[:user_id])
		unless @user.has_role?(@role.name)
			@user.roles << @role
		end
		redirect_to user_roles_url, notice: "Role was successfully added to user."
	end
	
	def destroy
		@role = Role.find(params[:id])
		@user = User.find(params[:user_id])
		if @user.has_role?(@role.name)
			@user.roles.delete(@role)
		end
		redirect_to user_roles_url, notice: "Role was successfully removed from user."
	end
	
end