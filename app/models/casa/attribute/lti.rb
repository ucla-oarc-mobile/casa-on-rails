module Casa
  module Attribute
    class Lti

      cattr_reader :name, :uuid

      @@name = 'lti'
      @@uuid = 'f6820326-5ea3-4a02-840d-7f91e75eb01b'

      class << self

        def make_for app
          data = nil

          if app.lti
            if app.app_lti_configs.count == 1
              config = app.app_lti_configs[0]
              data = {}
              data['launch_url'] = config.lti_launch_url if config.lti_launch_url
              data['launch_params'] = config.lti_launch_params if config.lti_launch_params
              data['registration_url'] = config.lti_registration_url if config.lti_registration_url
              data['configuration_url'] = config.lti_configuration_url if config.lti_configuration_url
              data['content_item_response'] = config.lti_content_item_message if config.lti_content_item_message
              data['outcomes'] = config.lti_lis_outcomes if config.lti_lis_outcomes
              data['version'] = config.lti_version if config.lti_version

              if app.has_lti_conformance_info?
                conformance = {}
                conformance['registration_number'] = config.ims_global_registration_number if config.ims_global_registration_number
                conformance['conformance_date'] = config.ims_global_conformance_date if config.ims_global_conformance_date
                conformance['link'] = config.ims_global_registration_link if config.ims_global_registration_link
                data['ims_global_certification'] = conformance unless conformance.empty?
              end
            else
              data = []
              app.app_lti_configs.each do |config|
                launch = {}
                launch['launch_url'] = config.lti_launch_url if config.lti_launch_url
                launch['launch_params'] = config.lti_launch_params if config.lti_launch_params
                launch['registration_url'] = config.lti_registration_url if config.lti_registration_url
                launch['configuration_url'] = config.lti_configuration_url if config.lti_configuration_url
                launch['content_item_response'] = config.lti_content_item_message if config.lti_content_item_message
                launch['outcomes'] = config.lti_lis_outcomes if config.lti_lis_outcomes
                launch['version'] = config.lti_version if config.lti_version

                if app.has_lti_conformance_info?
                  conformance = {}
                  conformance['registration_number'] = config.ims_global_registration_number if config.ims_global_registration_number
                  conformance['conformance_date'] = config.ims_global_conformance_date if config.ims_global_conformance_date
                  conformance['link'] = config.ims_global_registration_link if config.ims_global_registration_link
                  launch['ims_global_certification'] = conformance unless conformance.empty?
                end
                data << launch
              end
            end
            data
          else
            nil
          end
        end

      end

    end
  end
end
