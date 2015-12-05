class CategoriesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user
  before_action :set_category, only: [:edit, :update]

  def index
    @categories = Category.all.order('name ASC')
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category successfully added!'
      redirect_to categories_url
    else
      render 'new'
    end
  end

  def update
    if @category.update_attributes(category_params)
      flash[:success] = 'Category updated!'
      redirect_to categories_url
    else
      render 'edit'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
