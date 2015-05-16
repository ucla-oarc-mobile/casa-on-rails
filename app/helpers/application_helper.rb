module ApplicationHelper

  def engine
    @engine ||= Engine.new
  end

  def launch_provider
    @launch_provider ||= LaunchProvider.new(self)
  end

  def session_user
    @session_user ||= session['user_id'] ? User.find_by_id(session['user_id']) : nil
  end

  def bind_session_user! user
    session['user_id'] = user.try(:id)
    @session_user = nil
  end

  def unbind_session_user!
    session['user_id'] = nil
    @session_user = nil
  end

  def require_session_user!
    redirect_to session_path unless session_user
  end

  def require_session_admin!
    if session_user
      redirect_to root_path unless session_user.admin
    else
      redirect_to session_path
    end
  end

  class Engine

    attr_reader :uuid

    def initialize
      @uuid = Rails.application.config.casa[:engine][:uuid]
    end

  end

  class LaunchProvider

    def initialize app
      @app = app
      @type = @app.session.include?('launch_provider') ? @app.session['launch_provider'] : nil
    end

    def set type
      @app.session['launch_provider'] = type
      @type = type
    end

    def get
      @type
    end

    def destroy!
      set nil
    end

    def return_url app = nil
      if app
        case get
          when :lti
            "/lti/content_item/#{app.id}"
          when :mobile
            "/mobile/return/#{app.id}"
          when :cordova
            "/mobile/cordova/exec/#{app.id}"
          when :web_view_javascript_bridge
            "/mobile/web_view_javascript_bridge/send/#{app.id}"
          else
            false
        end
      else
        case get
          when :mobile
            "/mobile/abort"
          else
            false
        end
      end
    end

  end

end
