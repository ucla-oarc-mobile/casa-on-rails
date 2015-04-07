module Casa
  module Attribute
    class IosApp

      cattr_reader :name, :uuid

      @@name = 'ios_app'
      @@uuid = '4439d4f9-3b62-4710-9535-ae3ebf885dac'

      class << self

        def make_for app
          data = {}
          data['id'] = app.ios_app_id if app.ios_app_id
          data['scheme'] = app.ios_app_scheme if app.ios_app_scheme
          data['path'] = app.ios_app_path if app.ios_app_path
          data['affiliate-data'] = app.ios_app_affiliate_data if app.ios_app_affiliate_data
          data.keys.length > 0 ? data : nil
        end

      end

    end
  end
end
