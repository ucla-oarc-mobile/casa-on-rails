module Casa
  module Attribute
    class Caliper

      cattr_reader :name, :uuid

      @@name = 'caliper'
      @@uuid = 'f6820326-5ea3-4a02-840d-7f91e75eb01b'

      class << self

        def make_for app
          if app.caliper
            # Placeholder for serialization logic
            nil
          else
            nil
          end
        end

      end

    end
  end
end
