class AppsController < ApplicationController

  DEFAULT_CATEGORIES = ['Featured', 'Popular', 'Education', 'Campus Life', 'Community']

  def index

    @categories = Category.all

    if @site.homepage_categories and @site.homepage_categories.length > 0
      @collections = [];
      @site.homepage_categories.split(/\s*\n\s*/).each do |category_name|
        category = Category.where(name: category_name).first
        @collections << category if category && category.has_apps?
      end
    else
      @collections = DEFAULT_CATEGORIES.map(){|name| @categories.find(){ |c| c.name == name } }.delete_if(){ |c| c.nil? }
    end

  end

  def show

    @app = App.find params[:id]

    return render status: 404, plain: 'Not found' unless @app.enabled or (session_user and (session_user.admin or session_user.id == @app.created_by))

    @app_rating = AppRating.where(app_id: @app.id, user_id: session_user ? session_user.id : 0).first
    @app_rating = AppRating.new(app_id: @app.id) unless @app_rating

    if return_url = launch_provider.return_url(@app)
      @button = {
          text: 'Add',
          url: return_url
      }
    else
      @button = {
          text: 'Launch',
          url: @app.uri
      }
    end

  end

  def search

    @apps = App.where_query_string(params[:query]).available_to_launch_method(launch_provider.get)

  end

  def privacy
    @app = App.find params[:id]

    unless @app.privacy_url.blank?
      return redirect_to @app.privacy_url
    end
  end

end
