module Casa
  module Attribute
    class Privacy

      cattr_reader :name, :uuid

      @@name = 'privacy'
      @@uuid = '63a39b88-2603-4bce-ac5b-8247bf262986'

      class << self

        def make_for app
          return nil unless app.app_privacy_policy
          hash = app.app_privacy_policy.serializable_hash
          hash.delete 'id'
          data = {}
          hash.each do |key, value|
            classification = key.split('_')[0]
            type = key.split('_')[1]
            data[classification] = {} unless data.has_key?(classification)
            data[classification][type] = {} unless data[classification].has_key?(type)
            if value == 'true'
              data[classification][type] = true
            elsif value == 'false'
              data[classification][type] = false
            elsif value == '"optIn"'
              data[classification][type] = 'optIn'
            elsif value == '"optOut"'
              data[classification][type] = 'optOut'
            end
          end
          data
        end

      end

    end
  end
end
