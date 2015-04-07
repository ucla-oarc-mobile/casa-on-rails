class LtiController < ApplicationController

  ERROR_CODES = {
      400 => 'Bad Request',
      401 => 'Unauthorized',
      403 => 'Forbidden'
  }

  skip_before_action :verify_authenticity_token

  def launch

    launch = Lti::Launch.new params: params,
                             request: request,
                             session: session

    if launch.save!
      launch_provider.set :lti
      redirect_to root_path
    else
      launch_provider.destroy!
      render status: launch.error, plain: ERROR_CODES[launch.error]
    end

  end

  def content_item

    tp = Lti::ContentItemToolProvider.new_from_launch_params session: session

    if tp.nil?
      return render status: 400, plain: 'Bad request' # could not resolve a tool provider from launch params
    end

    app = App.find params[:id]
    app_content_item = app.to_content_item

    @parameters = tp.generate_content_item_response_parameters app_content_item
    @content_item_return_url = tp.content_item_return_url

    event.added app

    Lti::ContentItemToolProvider.destroy_launch! session: session
    launch_provider.destroy!

  end

end