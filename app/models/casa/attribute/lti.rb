module Casa
  module Attribute
    class Lti

      cattr_reader :name, :uuid

      @@name = 'lti'
      @@uuid = 'f6820326-5ea3-4a02-840d-7f91e75eb01b'

      class << self

        def make_for app
          if app.lti
            data = {}
            data['launch_url'] = app.lti_launch_url if app.lti_launch_url
            data['configuration_url'] = app.lti_configuration_url if app.lti_configuration_url
            data['registration_url'] = app.lti_registration_url if app.lti_registration_url
            data['versions_supported'] = app.app_lti_versions.map(){ |r| r.version } if app.app_lti_versions.length > 0
            data['outcomes'] = app.lti_outcomes if app.lti_outcomes
            data.keys.length > 0 ? data : true
          else
            nil
          end
        end

      end

    end
  end
end
