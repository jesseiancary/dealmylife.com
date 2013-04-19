class ProfileAddressesController < ApplicationController
	before_filter :login_required
	
	# GET /profile/addresses
	# GET /profile/addresses.json
	def index
		unless logged_in_user.profile.nil?
			@profile_address = logged_in_user.profile.addresses.all
	
			respond_to do |format|
				format.html # index.html.erb
				format.json	{ render json: @profile_address }
			end
		else
			redirect_to edit_profile_url, notice: 'Please create a Profile first.'
		end
	end

	# GET /profile/addresses/1
	# GET /profile/addresses/1.json
	def show
	  @profile_address = ProfileAddress.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json	{ render json: @profile_address }
		end
	end

	# GET /profile/addresses/new
	# GET /profile/addresses/new.json
	def new
		@profile_address = ProfileAddress.new
		@profile_address.address = Address.new

		respond_to do |format|
			format.html # new.html.erb
			format.json	{ render json: @profile_address }
		end
	end

	# GET /profile/addresses/1/edit
	def edit
    @profile_address = ProfileAddress.find(params[:id])
    #@address = logged_in_user.profile.addresses.find( logged_in_user.profile.profile_addresses.find(params[:id]).address_id )
	end

	# POST /profile/addresses
	# POST /profile/addresses.json
	def create
    @address = Address.new params[:profile_address][:address]
    @profile_address = ProfileAddress.new :profile => logged_in_user.profile, :address => @address, :label => params[:label], :default => logged_in_user.profile.profile_addresses.count.to_i.zero?
    
  	respond_to do |format|
  		
  		unless @address.geocode.nil?
  		  if @address.save and @profile_address.save
  			#if logged_in_user.profile.addresses << @address
  				format.html { redirect_to profile_addresses_url, notice: 'Address was successfully created.' }
  				format.json	{ render json: @profile_address, status: :created, :location => @profile_address }
  			else
  			  @address.destroy
          flash[:notice] = "We were unable to verify your address, please check your entries."
  				format.html { render :new }
  				format.json	{ render json: @profile_address.errors, status: :unprocessable_entity }
  			end
    	else
        @address.destroy
        flash[:notice] = "We were unable to verify your address, please check your entries."
        format.html { render :new }
        format.json { render json: @profile_address.errors, status: "We were unable to verify your address, please check your entries." }
    	end
    	
  	end
  	
	end

	# PUT /profile/addresses/1
	# PUT /profile/addresses/1.json
	def update
		@profile_address = ProfileAddress.find(params[:id])
		@address = Address.new(params[:profile_address][:address])
      
    respond_to do |format|
      
      unless @address.geocode.nil?
        if @profile_address.address.update_attributes(@address.attributes) and @profile_address.update_attributes(:label => params[:profile_address][:label], :default => logged_in_user.profile.profile_addresses.count(:conditions => "`default` = 1").to_i.zero?)
          @address.destroy
          format.html { redirect_to profile_addresses_url, notice: 'Address was successfully updated.' }
          format.json { render json: @profile_address, status: :created, :location => @profile_address }
        else
          @address.destroy
          flash[:notice] = "We were unable to verify your address, please check your entries."
          format.html { render :new }
          format.json { render json: @profile_address.errors, status: :unprocessable_entity }
        end
      else
        @address.destroy
        flash[:notice] = "We were unable to verify your address, please check your entries."
        format.html { render :new }
        format.json { render json: @profile_address.errors, status: "We were unable to verify your address, please check your entries." }
      end
      
    end
	end

	# DELETE /profile/addresses/1
	# DELETE /profile/addresses/1.json
	def destroy
    @profile_address = logged_in_user.profile.profile_addresses.find(params[:id])
		
		@profile_address.destroy

		respond_to do |format|
			format.html { redirect_to profile_addresses_url }
			format.json	{ head :ok }
		end
	end
	
	# PUT /profile/addresses/1/default
	def default
    @profile_address = ProfileAddress.find(params[:id])
	  
	  @profile_address.default = true
	  

    respond_to do |format|
      format.html { redirect_to profile_addresses_url }
      format.json { head :ok }
    end
	end
	
end