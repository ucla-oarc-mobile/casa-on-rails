require 'caliper/entities/discovery/portal'
require 'caliper/entities/discovery/publisher'
require 'caliper/entities/discovery/receiver'

module CasaCaliper
  class DiscoveryEntityFactory
    class << self

      def portal object
        engine = Caliper::Entities::Discovery::Portal.new
        apply_params engine, object
      end

      def publisher object
        engine = Caliper::Entities::Discovery::Publisher.new
        apply_params engine, object
      end

      def receiver object
        engine = Caliper::Entities::Discovery::Receiver.new
        apply_params engine, object
      end

      def apply_params engine, object = nil
        if object.is_a? ApplicationController
          engine.id = Rails.application.config.casa[:engine][:uuid]
          engine.name = object.root_url
        elsif object.is_a? Hash
          if object.has_key?(:id) and object[:id]
            engine.id = object[:id]
            engine.name = object[:name] if object.has_key?(:name)
            engine.description = object[:description] if object.has_key?(:description)
          else
            nil
          end
        else
          raise "No handler for #{object}"
        end
        engine
      end

    end
  end
end