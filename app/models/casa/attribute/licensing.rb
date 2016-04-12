module Casa
  module Attribute
    class Licensing

      cattr_reader :name, :uuid

      @@name = 'licensing'
      @@uuid = '664c2846-57c9-48fb-b6c1-5d5c2de290ab'

      class << self

        def make_for app
          data = {}
          %i(is_free is_paid is_recharge is_by_seat is_ad_supported is_other text).each do |field|
            field_data = app.public_send("license_#{field.to_s}".to_sym)
            data[field] = field_data unless field_data.nil?
          end
          data
        end

      end

    end
  end
end
