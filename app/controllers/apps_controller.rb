class AppsController < ApplicationController

  DEFAULT_CATEGORIES = ['Featured', 'Popular', 'Education', 'Campus Life', 'Community']

  def index

    @categories = Category.all
    if @site.homepage_categories and @site.homepage_categories.length > 0
      @collections = [];
      @site.homepage_categories.split(/\s*\n\s*/).each do |category_name|
        category = Category.where(name: category_name).first
        @collections << category if category.has_apps?
      end
    else
      @collections = DEFAULT_CATEGORIES.map(){|name| @categories.find(){ |c| c.name == name } }.delete_if(){ |c| c.nil? }
      @collection_apps = []

      @collections.each do |collection|
        @collection_apps[collection.id] = []
        collection.apps.where(enabled: true).available_to_launch_method(launch_provider.get).take(9).each do |app|
          Rails.logger.info "Sending event for app from collection"
          event.found app
          @collection_apps[collection.id] << app
        end
      end
    end
  end

  def show

    @app = App.find params[:id]

    return render status: 404, plain: 'Not found' unless @app.enabled or (session_user and (session_user.admin or session_user.id == @app.created_by))

    @app_rating = AppRating.where(app_id: @app.id, user_id: session_user ? session_user.id : 0).first
    @app_rating = AppRating.new(app_id: @app.id) unless @app_rating

    event.viewed @app

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

    @apps.each { |app| event.found app }

  end

end