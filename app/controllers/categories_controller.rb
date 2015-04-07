class CategoriesController < ApplicationController

  def show

    @category = Category.find params[:id]
    @apps = @category.apps.available_to_launch_method(launch_provider.get)

  end

end