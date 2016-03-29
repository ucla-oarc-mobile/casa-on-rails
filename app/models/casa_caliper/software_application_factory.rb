require 'caliper/entities/software_application'

module CasaCaliper
  class SoftwareApplicationFactory
    class << self

      def from object, data = nil
        if object.is_a? App
          from_app object, data
        elsif object.is_a? ApplicationHelper::LaunchProvider
          from_launch_provider object, data
        else
          raise "No handler for #{object}"
        end
      end

      def from_app app, data = nil
        object = Caliper::Entities::SoftwareApplication.new
        object.id = "#{app.payload_id}@#{app.payload_originator_id}"
        object.name = app.title if app.title
        object.description = app.short_description if app.short_description
        object.dateCreated = app.created_at.iso8601
        object.dateModified = app.updated_at.iso8601
        object
      end

      def from_launch_provider launch_provider, data = nil
        case launch_provider.get
          when :lti
            object = Caliper::Entities::SoftwareApplication.new
            object.id = data.tool_consumer_instance_guid
            object.name = data.tool_consumer_instance_name
            object.description = data.content_item_return_url
            object
          when :mobile
            object = Caliper::Entities::SoftwareApplication.new
            object.id =
            object
          when :cordova
            nil
          when :web_view_javascript_bridge
            nil
          else
            false
        end
      end

    end
  end
end