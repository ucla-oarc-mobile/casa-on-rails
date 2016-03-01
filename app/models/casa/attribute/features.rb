module Casa
  module Attribute
    class Features

      cattr_reader :name, :uuid

      @@name = 'features'
      @@uuid = 'a45a76b5-649a-42e1-b434-287c27f3d480'

      class << self

        def make_for app
          app.app_features.map(){ |f| f.feature_name }
        end

      end

    end
  end
end
