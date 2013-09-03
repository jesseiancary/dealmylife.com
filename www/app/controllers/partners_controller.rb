class PartnersController < ApplicationController
  before_filter :check_developer_role, :except => [ :show, :show_all ]
  before_filter :set_cache_buster
  
  # GET /partners
  # GET /partners.json
  def index
    @partners = Partner.all

    respond_to do |format|
      format.html # index.html.erb
      format.json  { render json: @partners }
    end
  end
  
  def show_all
    @partner = Partner.find_all_by_enabled(true)
    @marquee = "logo_md.png"
    @default_widgets = ["categories"]
    @categories = Category.select("id, name, ifnull(master_category_id, id) as master_category_id").order(:master_category_id, 1)
    
    ### if user enters a text address
    if params[:change_location] && params[:a] && !params[:a].empty?
      
      new_address = Address.new
      new_address = new_address.geocode params[:a]
      
    elsif logged_in_user
      
      ### if user selects saved address from dropdown
      if params[:pa_id]
        new_address = logged_in_user.profile.profile_addresses.find_by_id(params[:pa_id]).address
        
      elsif session[:address].nil?
        
        ### if user has a saved default address
        if logged_in_user.profile.addresses.length > 0
          new_address = logged_in_user.profile.addresses.all[0] # SHOULD GET DEFAULT ADDRESS HERE
          
        else
          new_address = Address.new
          new_address = new_address.geocode request.env["REMOTE_ADDR"].to_s
          
        end
        
      end
      
    end
    
    if !new_address.nil? && new_address.id != ( session[:address].try(:id) || 0 )
      session[:deals] = []
      session[:address] = new_address
      @partner.each do | partner |
        session[:deals] += partner.get_deals session[:address]
      end
    end
    
    unless session[:deals].nil?
      
      @total_items = session[:deals].length
      @page = [params[:p].to_i, 1].max
      @items_per_page = [params[:i].to_i, 5].max
      @total_pages = (@total_items / @items_per_page).ceil + 1
      @from = (@page * @items_per_page) - @items_per_page
      @to = @page * @items_per_page - 1
      
      if params[:s] && !params[:s].empty?
        @page = 1
        @items_per_page = 5
        @sort = params[:s].split(",")[0] || "remaining"
        @dir = params[:s].split(",")[1] || "asc"
        if @dir == "asc" then
          session[:deals].sort! do |a,b| a[@sort.to_sym] <=> b[@sort.to_sym] end
          #session[:deals].sort! do |a| a[@sort.to_sym] end
        elsif @dir == "desc" then
          session[:deals].sort! do |a,b| b[@sort.to_sym] <=> a[@sort.to_sym] end
          #session[:deals].sort! do |a| a[@sort.to_sym] end
        end
      end
      
    end
    
    respond_to do |format|
      if session[:address]
        @deals = session[:deals][@from..@to]
        #render :show <== WHY DOESN'T THIS WORK???  Want to share template.
        format.html # show_all.html.erb
        format.json  { render json: @partner }
      elsif logged_in_user
        notice = if flash[:notice] then flash[:notice] + " " else "" end
        format.html { redirect_to new_profile_address_path, notice: notice + "Please provide us with an address." }
      else
        format.html { redirect_to new_user_path }
      end
    end
  end

  # GET /partners/1
  # GET /partners/1.json
  def show
    @partner = Partner.find params[:id]
    @marquee = "logo_md.png"
    @default_widgets = ["categories"]
    @categories = Category.select("id, name, ifnull(master_category_id, id) as master_category_id").order(:master_category_id, 1)
    
    ### if user enters a text address
    if params[:a] && !params[:a].empty?
      
      new_address = Address.new
      new_address = new_address.geocode params[:a]
      
    elsif logged_in_user
      
      ### if user selects saved address from dropdown
      if params[:pa_id] && params[:pa_id] != ( session[:address].try(:id) || 0 )
        new_address = logged_in_user.profile.profile_addresses.find_by_id(params[:pa_id]).address
        
      elsif session[:address].nil?
        
        ### if user has a saved default address
        if !logged_in_user.profile.nil?
          new_address = logged_in_user.profile.addresses.all[0]#.try(:to_s) SHOULD GET DEFAULT ADDRESS HERE
          
        else
          new_address = Address.new
          new_address = new_address.geocode request.env["REMOTE_ADDR"].to_s
          
        end
        
      end
      
    end
    
    if params[:test]
      @rawdata = @partner.get_raw_data session[:address] = new_address
    else
      session[:deals] = []
      session[:deals] += @partner.get_deals session[:address] = new_address
    end
    
    unless session[:deals].nil?
      
      @total_items = session[:deals].length
      @page = [params[:p].to_i, 1].max
      @items_per_page = [params[:i].to_i, 5].max
      @total_pages = (@total_items / @items_per_page).ceil + 1
      @from = (@page * @items_per_page) - @items_per_page + 1
      @to = @page * @items_per_page
      
      if params[:s] && !params[:s].empty?
        @page = 1
        @items_per_page = 5
        @sort = params[:s].split(",")[0] || "remaining"
        @dir = params[:s].split(",")[1] || "asc"
        if @dir == "asc" then
          session[:deals].sort! { |a,b| a[@sort.to_sym] <=> b[@sort.to_sym] }
        elsif @dir == "desc" then
          session[:deals].sort! { |a,b| b[@sort.to_sym] <=> a[@sort.to_sym] }
        end
      end
      
    end
    
    respond_to do |format|
      if session[:address]
        @deals = session[:deals][@from..@to]
        #render :show <== WHY DOESN'T THIS WORK???  Want to share template.
        format.html # show_all.html.erb
        format.json  { render json: @partner }
      elsif logged_in_user
        notice = if flash[:notice] then flash[:notice] + " " else "" end
        format.html { redirect_to new_profile_address_path, notice: notice + "Please provide us with an address." }
      else
        format.html { redirect_to new_user_path }
      end
    end
  end

  # GET /partners/new
  # GET /partners/new.json
  def new
    @partner = Partner.new

    respond_to do |format|
      format.html # new.html.erb
      format.json  { render json: @partner }
    end
  end

  # GET /partners/1/edit
  def edit
    @partner = Partner.find(params[:id])
    @file = @partner.file
  end
  
  # PUT /partners/1/updatefile
  def updatefile
    @partner = Partner.find(params[:id])
    
    respond_to do |format|
      if @partner.file.save(params[:content])
        format.html { redirect_to edit_partner_url, notice: "Partner Template File was successfully updated." }
        format.json  { head :ok }
      else
        format.html { render action: "edit" }
        format.json  { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # POST /partners
  # POST /partners.json
  def create
    @partner = Partner.new(params[:partner])

    respond_to do |format|
      if @partner.save
        format.html { redirect_to partners_url, notice: "Partner was successfully created."  }
        format.json  { render json: @partner, status: :created, :location => @partner }
      else
        format.html { render action: "new" }
        format.json  { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /partners/1
  # PUT /partners/1.json
  def update
    @partner = Partner.find(params[:id])

    respond_to do |format|
      if @partner.update_attributes(params[:partner])
        format.html { redirect_to partners_url, notice: "Partner was successfully updated." }
        format.json  { head :ok }
      else
        format.html { render action: "edit" }
        format.json  { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partners/1
  # DELETE /partners/1.json
  def destroy
    @partner = Partner.find(params[:id])
    @partner.destroy

    respond_to do |format|
      format.html { redirect_to partners_url }
      format.json  { head :ok }
    end
  end
  
  # PUT /partners/:id/enable
  # PUT /partners/:id/enable.json
  def enable
    @partner = Partner.find(params[:id])
    
    respond_to do |format|
      if @partner.update_attribute(:enabled, true)
        format.html { redirect_to partners_url, notice: "Partner Enabled" }
        format.json { head :ok }
      else
        format.html { redirect_to partners_url, notice: "There was an error enabling this Partner" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
  # PUT /partners/:id/disable
  # PUT /partners/:id/disable.json
  def disable
    @partner = Partner.find(params[:id])
    
    respond_to do |format|
      if @partner.update_attribute(:enabled, false)
        format.html { redirect_to partners_url, notice: "Partner Disabled" }
        format.json { head :ok }
      else
        format.html { redirect_to partners_url, notice: "There was an error disabling this Partner" }
        format.json { render json: @partner.errors, status: :unprocessable_entity }
      end
    end
    
  end
  
end
