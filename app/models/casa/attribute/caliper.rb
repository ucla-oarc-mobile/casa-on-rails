module Casa
  module Attribute
    class Caliper

      cattr_reader :name, :uuid

      @@name = 'caliper'
      @@uuid = 'd96e4185-c52d-4f46-9fcb-59d28087c7d1'

      class << self

        def make_for app
          if app.caliper
            data = JSON.parse(app.caliper_metric_profiles)
            data.merge JSON.parse(app.caliper_ims_global_certifications) if app.caliper_ims_global_certifications
          end
        end

      end

    end
  end
end
