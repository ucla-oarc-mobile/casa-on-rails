module Casa
  module Attribute
    class Security

      cattr_reader :name, :uuid

      @@name = 'security'
      @@uuid = 'f0cdc88e-4f39-47cb-9356-307fee2c777f'

      class << self

        def make_for app
          data = {}
          %i(uses_https uses_additional_encryption requires_cookies requires_third_party_cookies
             session_lifetime cloud_vendor policy_url sla_url text ).each do |field|
            field_data = app.public_send("security_#{field.to_s}".to_sym)
            data[field] = field_data unless field_data.nil?
          end
          data
        end

      end

    end
  end
end
