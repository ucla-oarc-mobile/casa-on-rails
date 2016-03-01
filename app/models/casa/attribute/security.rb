module Casa
  module Attribute
    class Security

      cattr_reader :name, :uuid

      @@name = 'security'
      @@uuid = 'f0cdc88e-4f39-47cb-9356-307fee2c777f'

      class << self

        def make_for app
          data = {}
          %i(security_uses_https security_uses_additional_encryption security_requires_cookies security_requires_third_party_cookies
             security_session_lifetime security_cloud_vendor security_policy_url security_text ).each do |field|
            data[field] = app.public_send(field) if app.public_send(field)
          end
          data
        end

      end

    end
  end
end
