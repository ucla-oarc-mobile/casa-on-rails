require 'rest_client'

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

  def event
    @event_handler ||= EventHandler.new(self)
  end

  class EventHandler

    def initialize controller
      @controller = controller
    end

    def send_event event

      if Rails.application.config.caliper and Rails.application.config.caliper.has_key?(:event_store) and Rails.application.config.caliper[:event_store].has_key?(:url)
        RestClient.post Rails.application.config.caliper[:event_store][:url],
                        [{
                            'apiKey' => Rails.application.config.caliper[:event_store][:api_key],
                            'sensorId' => Rails.application.config.caliper[:event_store][:sensor_id],
                            'event' => event
                         }].to_json,
                        :content_type => :json,
                        :accept => :json
      end

      Logger.new(STDOUT).info([{
                                   'url' => Rails.application.config.caliper[:event_store][:url],
                                   'apiKey' => Rails.application.config.caliper[:event_store][:api_key],
                                   'sensorId' => Rails.application.config.caliper[:event_store][:sensor_id],
                                   'event' => event
                               }].to_json)

    end

    def fire_engine_event message, params
      send_event CasaCaliper::DiscoveryEventsFactory.send message, params
    end

    def fire_user_event message, params

      case @controller.launch_provider.get
        when :lti
          params[:launch_data] = Lti::ContentItemToolProvider.new_from_launch_params(session: @controller.session)
        when :mobile
          params[:launch_data] = {
            mobile_url: @controller.mobile_url
          }
      end

      send_event CasaCaliper::DiscoveryEventsFactory.send message, params

    end

    def shared app, params = {}
      begin
        fire_engine_event :shared,
                          {
                            engine: @controller,
                            app: app,
                            peer_engine: {
                              id: params.has_key?(:peer_id) ? params[:peer_id] : nil,
                              name: params.has_key?(:peer_name) ? params[:peer_name] : nil,
                              description: params.has_key?(:peer_description) ? params[:peer_description] : nil
                            }
                          }
      rescue; end
    end

    def accepted payload, params = {}
      begin
        fire_engine_event :accepted,
                          {
                            engine: @controller,
                            payload: payload,
                            peer_engine: {
                              id: params.has_key?(:peer_id) ? params[:peer_id] : nil,
                              name: params.has_key?(:peer_name) ? params[:peer_name] : nil,
                              description: params.has_key?(:peer_description) ? params[:peer_description] : nil
                            },
                            started_at: payload.created_at
                          }
      rescue; end
    end

    def rejected payload, params = {}
      begin
        fire_engine_event :rejected,
                          {
                            engine: @controller,
                            payload: payload,
                            peer_engine: {
                              id: params.has_key?(:peer_id) ? params[:peer_id] : nil,
                              name: params.has_key?(:peer_name) ? params[:peer_name] : nil,
                              description: params.has_key?(:peer_description) ? params[:peer_description] : nil
                            },
                            started_at: payload.created_at
                          }
      rescue; end
    end

    def added app, params = {}
      begin
        fire_user_event :added,
                        {
                          engine: @controller,
                          app: app,
                          launch_provider: @controller.launch_provider
                        }.merge(params)
      rescue; end
    end

    def found app, params = {}
      begin
        fire_user_event :found,
                        {
                          engine: @controller,
                          app: app,
                          launch_provider: @controller.launch_provider
                        }.merge(params)
      rescue; end
    end

    def viewed app, params = {}
      begin
        fire_user_event :viewed,
                        {
                          engine: @controller,
                          app: app,
                          launch_provider: @controller.launch_provider
                        }.merge(params)
      rescue; end
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

    def return_url app
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
    end

  end

end
