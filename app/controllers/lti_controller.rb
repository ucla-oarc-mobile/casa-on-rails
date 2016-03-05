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

    # If the store was launched with an LTI Consumer that has a data store config,
    # return that information with the ContentItemResponse so the data store info
    # can be included with each launch of the app.
    if session['tp_metadata']
      event_store_url = session['tp_metadata']['event_store_url']
      event_store_api_key = session['tp_metadata']['event_store_api_key']

      # There should always be a 'custom' object, but make sure.
      if app_content_item['custom']
        app_content_item['custom']['event_store_url'] = event_store_url if event_store_url
        app_content_item['custom']['event_store_api_key'] = event_store_api_key if event_store_api_key
      else
        custom = {}
        custom['event_store_url'] = event_store_url if event_store_url
        custom['event_store_api_key'] = event_store_api_key if event_store_api_key
        app_content_item['custom'] = custom unless custom.blank?
      end
    end
    
    @parameters = tp.generate_content_item_response_parameters app_content_item
    @content_item_return_url = tp.content_item_return_url

    Lti::ContentItemToolProvider.destroy_launch! session: session
    launch_provider.destroy!

  end

end