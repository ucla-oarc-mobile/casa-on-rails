module Mobile
  class CordovaController < ApplicationController

    skip_before_action :verify_authenticity_token

    def launch

      launch_provider.set :cordova
      redirect_to root_path

    end

    def exec

      @app = App.find params[:id]
      launch_provider.destroy!

    end

  end
end