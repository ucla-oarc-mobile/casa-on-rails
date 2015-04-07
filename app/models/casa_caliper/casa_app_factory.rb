require 'caliper/entities/discovery/casa_app'

module CasaCaliper
  class CasaAppFactory
    class << self

      def from object
        if object.is_a? App
          from_app object
        elsif object.is_a? InPayload
          from_payload object
        else
          raise "No handler for #{object}"
        end
      end

      def from_app app
        object = Caliper::Entities::Discovery::CasaApp.new
        object.id = "#{app.payload_id}@#{app.payload_originator_id}"
        object.name = app.title if app.title
        object.description = app.short_description if app.short_description
        object.uri = app.uri
        object.payload = app.to_transit_payload
        object.dateCreated = app.created_at.iso8601
        object.dateModified = app.updated_at.iso8601
        object
      end

      def from_payload payload
        object = Caliper::Entities::Discovery::CasaApp.new
        object.id = "#{payload.casa_id}@#{payload.casa_originator_id}"
        object.uri = payload.content_data['attributes']['uri']
        object.payload = JSON.parse(payload.original_content)
        object.dateCreated = Time.parse(payload.content_data['original']['timestamp']).iso8601
        object.dateModified = payload.casa_timestamp.iso8601
        object
      end

    end
  end
end