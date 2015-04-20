require 'caliper/event/discovery_event'
require 'caliper/profiles/discovery_profile'

module CasaCaliper
  class DiscoveryEventsFactory
    class << self

      # Node-based actions

      def shared params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = CasaCaliper::DiscoveryEntityFactory.publisher params[:engine]
        event.action = Caliper::Profiles::DiscoveryActions::SHARED
        event.object = CasaCaliper::CasaAppFactory.from params[:app]
        event.target = CasaCaliper::DiscoveryEntityFactory.receiver params[:peer_engine]
        event.startedAtTime = Time.now.iso8601
        event

      end

      def accepted params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = CasaCaliper::DiscoveryEntityFactory.receiver params[:engine]
        event.action = Caliper::Profiles::DiscoveryActions::ACCEPTED
        event.object = CasaCaliper::CasaAppFactory.from params[:payload]
        event.source = CasaCaliper::DiscoveryEntityFactory.publisher params[:peer_engine]
        event.startedAtTime = (params[:started_at].respond_to?(:iso8601) ? params[:started_at] : Time.parse(params[:started_at])).iso8601
        event.endedAtTime = Time.now.iso8601
        event

      end

      def rejected params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = CasaCaliper::DiscoveryEntityFactory.receiver params[:engine]
        event.action = Caliper::Profiles::DiscoveryActions::REJECTED
        event.object = CasaCaliper::CasaAppFactory.from params[:payload]
        event.source = CasaCaliper::DiscoveryEntityFactory.publisher params[:peer_engine]
        event.startedAtTime = (params[:started_at].respond_to?(:iso8601) ? params[:started_at] : Time.parse(params[:started_at])).iso8601
        event.endedAtTime = Time.now.iso8601
        event

      end

      # Person-based actions

      def found params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = nil # TODO -- maybe like... CasaCaliper::PersonFactory.from params[:launch_provider], (params.has_key?(:launch_data) ? params[:launch_data] : nil)
        event.action = Caliper::Profiles::DiscoveryActions::FOUND
        event.source  = CasaCaliper::DiscoveryEntityFactory.portal params[:engine]
        event.object = CasaCaliper::SoftwareApplicationFactory.from params[:app]
        event.target = CasaCaliper::SoftwareApplicationFactory.from params[:launch_provider], (params.has_key?(:launch_data) ? params[:launch_data] : nil)
        event.startedAtTime = Time.now.iso8601
        event

      end

      def viewed params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = nil # TODO
        event.action = Caliper::Profiles::DiscoveryActions::VIEWED
        event.source  = CasaCaliper::DiscoveryEntityFactory.portal params[:engine]
        event.object = CasaCaliper::CasaAppFactory.from params[:app]
        event.target = CasaCaliper::SoftwareApplicationFactory.from params[:launch_provider], (params.has_key?(:launch_data) ? params[:launch_data] : nil)
        event.startedAtTime = Time.now.iso8601
        event

      end

      def added params

        event = Caliper::Event::DiscoveryEvent.new
        event.actor = nil # TODO
        event.action = Caliper::Profiles::DiscoveryActions::ADDED
        event.source  = CasaCaliper::DiscoveryEntityFactory.portal params[:engine]
        event.object = CasaCaliper::CasaAppFactory.from params[:app]
        event.target = CasaCaliper::SoftwareApplicationFactory.from params[:launch_provider], (params.has_key?(:launch_data) ? params[:launch_data] : nil)
        event.startedAtTime = Time.now.iso8601
        event

      end

    end
  end
end