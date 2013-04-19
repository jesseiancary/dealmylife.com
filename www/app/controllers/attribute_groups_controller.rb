class AttributeGroupsController < ApplicationController
	before_filter :check_developer_role
	before_filter :login_required
	
	# GET /attribute_groups
	# GET /attribute_groups.json
	def index
		@attribute_groups = AttributeGroup.all

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @attribute_groups }
		end
	end

	# GET /attribute_groups/1
	# GET /attribute_groups/1.json
	def show
		@attribute_group = AttributeGroup.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @attribute_group }
		end
	end

	# GET /attribute_groups/new
	# GET /attribute_groups/new.json
	def new
		@attribute_group = AttributeGroup.new

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @attribute_group }
		end
	end

	# GET /attribute_groups/1/edit
	def edit
		@attribute_group = AttributeGroup.find(params[:id])
	end

	# POST /attribute_groups
	# POST /attribute_groups.json
	def create
		@attribute_group = AttributeGroup.new(params[:attribute_group])

		respond_to do |format|
			if @attribute_group.save
				format.html { redirect_to attribute_groups_url, notice: 'Attribute Group was successfully created.' }
				format.json	{ render json: @attribute_group, status: :created, :location => @attribute_group }
			else
				format.html { render action: "new" }
				format.json	{ render json: @attribute_group.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /attribute_groups/1
	# PUT /attribute_groups/1.json
	def update
		@attribute_group = AttributeGroup.find(params[:id])

		respond_to do |format|
			if @attribute_group.update_attributes(params[:attribute_group])
				format.html { redirect_to attribute_groups_url, notice: 'Attribute Group was successfully updated.' }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @attribute_group.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /attribute_groups/1
	# DELETE /attribute_groups/1.json
	def destroy
		@attribute_group = AttributeGroup.find(params[:id])
		@attribute_group.destroy

		respond_to do |format|
			format.html { redirect_to attribute_groups_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /attribute_groups/:id/enable
	# PUT /attribute_groups/:id/enable.json
	def enable
		@attribute_group = AttributeGroup.find(params[:id])
		
		respond_to do |format|
			if @attribute_group.update_attribute(:enabled, true)
				format.html { redirect_to attribute_groups_url, notice: "Attribute Group Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to attribute_groups_url, notice: "There was an error enabling this Attribute Group" }
				format.json	{ render json: @attribute_group.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /attribute_groups/:id/disable
	# PUT /attribute_groups/:id/disable.json
	def disable
		@attribute_group = AttributeGroup.find(params[:id])
		
		respond_to do |format|
			if @attribute_group.update_attribute(:enabled, false)
				format.html { redirect_to attribute_groups_url, notice: "Attribute Group Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to attribute_groups_url, notice: "There was an error disabling this Attribute Group" }
				format.json	{ render json: @attribute_group.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
end