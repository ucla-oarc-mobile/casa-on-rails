module Mobile
  class WebViewJavascriptBridgeController < ApplicationController

    skip_before_action :verify_authenticity_token

    def launch

      launch_provider.set :web_view_javascript_bridge
      redirect_to root_path

    end

    def _send #send is a reserved keyword

      @app = App.find params[:id]
      launch_provider.destroy!

    end

  end
end