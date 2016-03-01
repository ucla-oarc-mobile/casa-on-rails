module Casa
  module Attribute
    class Licensing

      cattr_reader :name, :uuid

      @@name = 'licensing'
      @@uuid = '664c2846-57c9-48fb-b6c1-5d5c2de290ab'

      class << self

        def make_for app
          data = {}
          %i(license_is_free license_is_paid license_is_recharge license_is_by_seat license_is_ad_supported
             license_is_other license_text).each do |field|
            data[field] = app.public_send(field) if app.public_send(field)
          end
          data
        end

      end

    end
  end
end
