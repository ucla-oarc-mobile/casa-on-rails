module Casa
  module Attribute
    class Caliper

      cattr_reader :name, :uuid

      @@name = 'caliper'
      @@uuid = 'f6820326-5ea3-4a02-840d-7f91e75eb01b'

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
