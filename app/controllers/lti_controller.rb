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

    # If the store was launched with an LTI Tool Consumer that has its own TC-wide configuration data,
    # return that information with the ContentItemResponse so it can be included with each launch of the app.
    if session['tp_metadata']
      event_store_url = session['tp_metadata']['event_store_url']
      event_store_api_key = session['tp_metadata']['event_store_api_key']
      sso_type = session['tp_metadata']['sso_type']
      sso_idp_url = session['tp_metadata']['sso_idp_url']

      # There should always be a 'custom' object, but make sure.
      custom = app_content_item['custom'].blank? ? {} : app_content_item['custom']

      custom['event_store_url'] = event_store_url if event_store_url
      custom['event_store_api_key'] = event_store_api_key if event_store_api_key
      custom['sso_type'] = sso_type if sso_type
      custom['sso_idp_url'] = sso_idp_url if sso_idp_url

      app_content_item['custom'] = custom unless custom.blank?
      session.delete('tp_metadata')
    end

    @parameters = tp.generate_content_item_response_parameters app_content_item
    @content_item_return_url = tp.content_item_return_url

    Lti::ContentItemToolProvider.destroy_launch! session: session
    launch_provider.destroy!

  end

end