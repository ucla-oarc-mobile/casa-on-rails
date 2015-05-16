require 'json'

class MobileController < ApplicationController

  skip_before_action :verify_authenticity_token

  def initialize
    @local_storage_key = 'casa-apps'
    @default_apps = App.where.not(default_app_order: nil).order(default_app_order: :asc).map() do |a|
      { title: a.title, uri: a.uri, icon: a.icon }
    end
  end

  def index
    render layout: false
  end

  def launch
    launch_provider.set :mobile
    redirect_to '/'
  end

  def return
    @app = App.find params[:id]
    @location = mobile_url
    launch_provider.destroy!
    render layout: 'application'
  end

  def abort
    launch_provider.destroy!
    redirect_to mobile_url
  end

end