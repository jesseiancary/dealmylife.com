class AttributesController < ApplicationController
	before_filter :check_developer_role
	before_filter :login_required
	
	# GET /attributes
	# GET /attributes.json
	def index
		@attributes = Attribute.all

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @attributes }
		end
	end

	# GET /attributes/1
	# GET /attributes/1.json
	def show
		@attribute = Attribute.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @attribute }
		end
	end

	# GET /attributes/new
	# GET /attributes/new.json
	def new
		@attribute = Attribute.new
		@attribute_groups = AttributeGroup.all(:order => :id)
		@attribute_types = AttributeType.all(:order => :id)

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @attribute }
		end
	end

	# GET /attributes/1/edit
	def edit
		@attribute = Attribute.find(params[:id])
		@attribute_groups = AttributeGroup.all(:order => :id)
		@attribute_types = AttributeType.all(:order => :id)
	end

	# POST /attributes
	# POST /attributes.json
	def create
		@attribute = Attribute.new(params[:attribute])
		#attribute_group = AttributeGroup.find(params[:attribute][:attribute_group_id])
		#@attribute = attribute_group.attributes.new(params[:attribute])

		respond_to do |format|
			if @attribute.save
				format.html { redirect_to @attribute, notice: 'Attribute was successfully created.' }
				format.json	{ render json: @attribute, status: :created, :location => @attribute }
			else
				format.html { render action: "new" }
				format.json	{ render json: @attribute.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /attributes/1
	# PUT /attributes/1.json
	def update
		@attribute = Attribute.find(params[:id])

		respond_to do |format|
			if @attribute.update_attributes(params[:attribute])
				format.html { redirect_to @attribute, notice: 'Attribute was successfully updated.' }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @attribute.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /attributes/1
	# DELETE /attributes/1.json
	def destroy
		@attribute = Attribute.find(params[:id])
		@attribute.destroy

		respond_to do |format|
			format.html { redirect_to attributes_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /attributes/:id/enable
	# PUT /attributes/:id/enable.json
	def enable
		@attribute = Attribute.find(params[:id])
		
		respond_to do |format|
			if @attribute.update_attribute(:enabled, true)
				format.html { redirect_to attributes_url, notice: "Attribute Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to attributes_url, notice: "There was an error enabling this Attribute" }
				format.json	{ render json: @attribute.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /attributes/:id/disable
	# PUT /attributes/:id/disable.json
	def disable
		@attribute = Attribute.find(params[:id])
		
		respond_to do |format|
			if @attribute.update_attribute(:enabled, false)
				format.html { redirect_to attributes_url, notice: "Attribute Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to attributes_url, notice: "There was an error disabling this Attribute" }
				format.json	{ render json: @attribute.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
end