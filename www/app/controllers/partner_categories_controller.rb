class PartnerCategoriesController < ApplicationController
  before_filter :check_developer_role, :except => [ :show ]

  # GET /partners/:partner_id/categories
  # GET /partners/:partner_id/categories.json
  def index
    @partner = Partner.find(params[:partner_id])
    @categories = @partner.partner_categories.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /partners/:partner_id/categories/1
  # GET /partners/:partner_id/categories/1.json
  def show
    @category = PartnerCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /partners/:partner_id/categories/new
  # GET /partners/:partner_id/categories/new.json
  def new
    @partner = Partner.find(params[:partner_id])
    @category = PartnerCategory.new
    @master_categories = Category.where( :master_category_id => nil )
    @sub_categories = Category.where( "master_category_id is not null" )

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /partners/:partner_id/categories/1/edit
  def edit
    @partner = Partner.find(params[:partner_id])
    @category = PartnerCategory.find(params[:id])
    @master_categories = Category.where( :master_category_id => nil )
    @sub_categories = Category.where( "master_category_id is not null" )
  end

  # POST /partners/:partner_id/categories
  # POST /partners/:partner_id/categories.json
  def create
    @category = PartnerCategory.new(params[:partner_category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to partner_categories_url, notice: 'Partner category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /partners/:partner_id/categories/1
  # PUT /partners/:partner_id/categories/1.json
  def update
    @category = PartnerCategory.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:partner_category])
        format.html { redirect_to partner_categories_url, notice: 'Partner category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partners/:partner_id/categories/1
  # DELETE /partners/:partner_id/categories/1.json
  def destroy
    @category = PartnerCategory.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to partner_categories_url }
      format.json { head :ok }
    end
  end
  
end
