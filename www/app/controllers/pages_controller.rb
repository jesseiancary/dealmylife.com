class PagesController < ApplicationController
	before_filter :check_editor_role, :except => [ :show_by_permalink, :show ]
	
	# GET /pages
	# GET /pages.json
	def index
		@pages = Page.all

		respond_to do |format|
			format.html # index.html.erb
			format.json	{ render json: @pages }
		end
	end

	# GET /pages/1
	# GET /pages/1.json
	def show
		@page = Page.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @page }
		end
	end
	
	def show_by_permalink
		@page = Page.find_by_permalink(params[:permalink])

		respond_to do |format|
			if @page and @page.enabled
				format.html { render action: "show" }
				format.json	{ render json: @page }
			else
				format.html { redirect_to index_url }
				format.json	{ render json: @page, status: "unavailable" }
			end
		end
	end

	# GET /pages/new
	# GET /pages/new.json
	def new
		@page = Page.new

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @page }
		end
	end

	# GET /pages/1/edit
	def edit
		@page = Page.find(params[:id])
	end

	# POST /pages
	# POST /pages.json
	def create
		@page = Page.new(params[:page])

		respond_to do |format|
			if @page.save
				format.html { redirect_to pages_url, notice: 'Page was successfully created.' }
				format.json	{ render json: @page, status: :created, :location => @page }
			else
				format.html { render action: "new" }
				format.json	{ render json: @page.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /pages/1
	# PUT /pages/1.json
	def update
		@page = Page.find(params[:id])

		respond_to do |format|
			if @page.update_attributes(params[:page])
				format.html { redirect_to pages_url, notice: 'Page was successfully updated.' }
				format.json	{ head :ok }
			else
				format.html { render action: "edit" }
				format.json	{ render json: @page.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /pages/1
	# DELETE /pages/1.json
	def destroy
		@page = Page.find(params[:id])
		@page.destroy

		respond_to do |format|
			format.html { redirect_to pages_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /pages/:id/enable
	# PUT /pages/:id/enable.json
	def enable
		@page = Page.find(params[:id])
		
		respond_to do |format|
			if @page.update_attribute(:enabled, true)
				format.html { redirect_to pages_url, notice: "Page Enabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to pages_url, notice: "There was an error enabling this Page" }
				format.json	{ render json: @page.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
	# PUT /pages/:id/disable
	# PUT /pages/:id/disable.json
	def disable
		@page = Page.find(params[:id])
		
		respond_to do |format|
			if @page.update_attribute(:enabled, false)
				format.html { redirect_to pages_url, notice: "Page Disabled" }
				format.json	{ head :ok }
			else
				format.html { redirect_to pages_url, notice: "There was an error disabling this Page" }
				format.json	{ render json: @page.errors, status: :unprocessable_entity }
			end
		end
		
	end
	
end
