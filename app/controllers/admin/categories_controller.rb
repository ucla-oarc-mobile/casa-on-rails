module Admin
  class CategoriesController < ApplicationController

    before_action :require_session_admin!

    def index
      @categories = Category.all
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new category_params
      @category.app_ids = params[:category][:apps]
      if @category.save
        redirect_to category_url @category
      else
        render 'new'
      end
    end

    def edit
      @category = Category.find params[:id]
      @apps = App.all
    end

    def update
      @category = Category.find params[:id]
      @category.app_ids = params[:category][:apps]
      if @category.update category_params
        redirect_to category_url @category
      else
        render 'edit'
      end
    end

    def destroy
      @category = Category.find params[:id]
      @category.destroy
      redirect_to admin_categories_path
    end

  private

    def category_params
      params.require(:category).permit([
        :name
      ])
    end

  end
end