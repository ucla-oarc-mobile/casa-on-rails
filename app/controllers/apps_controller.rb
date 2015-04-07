class AppsController < ApplicationController

  DEFAULT_CATEGORIES = ['Featured', 'Popular', 'Education', 'Campus Life', 'Community']

  def index

    @categories = Category.all
    @collections = DEFAULT_CATEGORIES.map(){|name| @categories.find(){ |c| c.name == name } }.delete_if(){ |c| c.nil? }

  end

  def show

    @app = App.find params[:id]

    return render status: 404, plain: 'Not found' unless @app.enabled or (session_user and session_user.admin)

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

end