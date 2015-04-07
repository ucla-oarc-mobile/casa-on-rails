module Casa
  module Attribute
    class BrowserFeatures

      cattr_reader :name, :uuid

      @@name = 'browser_features'
      @@uuid = 'ef1c6344-5e2e-4dba-8fff-1638852694f8'

      class << self

        def make_for app
          data = {}
          app.app_browser_features.each do |f|
            data[f.feature] = f.level
          end
          data
        end

      end

    end
  end
end
