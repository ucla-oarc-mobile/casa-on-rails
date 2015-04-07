require 'caliper/entities/lis/person'

module CasaCaliper
  class PersonFactory
    class << self

      def from object, data = nil
        if object.is_a? ApplicationHelper::LaunchProvider
          from_launch_provider object, data
        else
          raise "No handler for #{object}"
        end
      end

      def from_launch_provider launch_provider, data = nil
        case launch_provider.get
          when :lti
            person = Caliper::Entities::LIS::Person.new
            person.id = "#{data.tool_consumer_instance_guid}/#{data.user_id}"
            person.name = data.lis_person_name_full
            person.dateCreated = data.oauth_timestamp
            person
          when :mobile
            nil # TODO
          when :cordova
            nil # TODO
          when :web_view_javascript_bridge
            nil # TODO
          else
            false
        end
      end

    end
  end
end