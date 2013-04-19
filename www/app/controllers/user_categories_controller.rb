class UserCategoriesController < ApplicationController
  #before_filter :is_logged_in_user

  # GET /users/:user_id/categories
  # GET /users/:user_id/categories.json
  def index
    @all_categories = Category.all
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @all_categories }
    end
  end
  
  # PUT /users/:user_id/category?id=:id
  def update
    @category = Category.find(params[:id])
    @user = User.find(params[:user_id])
    unless @user.has_category?(@category.id)
      @user.categories << @category
    end
    redirect_to user_categories_url, notice: "Category was successfully added to user."
  end
  
  # DELETE /users/:user_id/category?id=:id
  def destroy
    @category = Category.find(params[:id])
    @user = User.find(params[:user_id])
    if @user.has_category?(@category.id)
      @user.categories.delete(@category)
    end
    redirect_to user_categories_url, notice: "Category was successfully removed from user."
  end
  
end