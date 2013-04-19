class WidgetsController < ApplicationController
	before_filter :check_developer_role, :except => [ :list, :assign, :remove ]
	before_filter :login_required
	
	# GET /widgets
	# GET /widgets.json
	def index
		@widgets = Widget.all

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @widgets }
		end
	end

	# GET /widgets/:id
	# GET /widgets/:id.json
	def show
		@widget = Widget.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @widget }
		end
	end

	# GET /widgets/new
	# GET /widgets/new.json
	def new
		@widget = Widget.new

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @widget }
		end
	end

	# GET /widgets/1/edit
	def edit
		@widget = Widget.find(params[:id])
	end

	# POST /widgets
	# POST /widgets.json
	def create
		@widget = Widget.new(params[:widget])

		respond_to do |format|
			if @widget.save
				format.html { redirect_to @widget, notice: 'Widget was successfully created.' }
				format.json	{ render json: @widget, status: :created, :location => @widget }
			else
				format.html { render action: "new" }
				format.json	{ render json: @widget.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /widgets/:id
	# PUT /widgets/:id.json
	def update
		@widget = Widget.find(params[:id])

		respond_to do |format|
			if @widget.update_attributes(params[:widget])
				format.html { redirect_to @widget, notice: 'Widget was successfully updated.' }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @widget.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /widgets/:id
	# DELETE /widgets/:id.json
	def destroy
		@widget = Widget.find(params[:id])
		@widget.destroy

		respond_to do |format|
			format.html { redirect_to widgets_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /widgets/:id/enable
	# PUT /widgets/:id/enable.json
	def enable
		@widget = Widget.find(params[:id])
		
		respond_to do |format|
			if @widget.update_attribute(:enabled, true)
				format.html { redirect_to widgets_url, notice: "Widget Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to widgets_url, notice: "There was an error enabling this Widget" }
				format.json	{ render json: @widget.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /widgets/:id/disable
	# PUT /widgets/:id/disable.json
	def disable
		@widget = Widget.find(params[:id])
		
		respond_to do |format|
			if @widget.update_attribute(:enabled, false)
				format.html { redirect_to widgets_url, notice: "Widget Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to widgets_url, notice: "There was an error disabling this Widget" }
				format.json	{ render json: @widget.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# GET /users/:user_id/widgets
	# GET /users/:user_id/widgets.json
	def list
		@widgets = Widget.find_all_by_enabled(true)
		@user = User.find(params[:user_id])

		respond_to do |format|
			format.html { render action: "index" }
			format.json	{ render json: @widgets }
		end
	end
	
	# PUT /users/:user_id/widget?id=:id
	def assign
		@widget = Widget.find(params[:id])
		@user = User.find(params[:user_id])
		
		container = if params[:container] then params[:container] else "side_left" end
		order = if params[:order] then params[:order] else 1000 end
		
		if @user.has_widget?(@widget.name)
			@user.widgets.delete(@widget)
		end
		
		if @widget.enabled
			#@user.widgets << @widget	# I don't think this method of assignment works due to the extra parameters in the lookup table. Use UserWidget.create() instead.
			UserWidget.create(:user => @user, :widget => @widget, :container => container, :order => order)
		end
		
		respond_to do |format|
			format.html { redirect_to user_widgets_url, notice: "Widget was successfully added to user profile." }
		end
	end
	
	# DELETE /users/:user_id/widget?id=:id
	def remove
		@widget = Widget.find(params[:id])
		@user = User.find(params[:user_id])
		if @user.has_widget?(@widget.name)
			@user.widgets.delete(@widget)
		end
		
		respond_to do |format|
			format.html { redirect_to user_widgets_url, notice: "Widget was successfully removed from user profile." }
		end
	end
	
end
