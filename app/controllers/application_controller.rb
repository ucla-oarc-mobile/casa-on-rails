class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  helper_method :engine
  helper_method :launch_provider
  helper_method :session_user
  helper_method :bind_session_user!
  helper_method :unbind_session_user!
  helper_method :require_session_user!
  helper_method :require_session_admin!

  before_filter do
    response.headers.delete('X-Frame-Options')
  end

  before_action do
    @site = Site.take(1).first
  end

end
