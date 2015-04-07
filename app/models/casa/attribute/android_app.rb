module Casa
  module Attribute
    class AndroidApp

      cattr_reader :name, :uuid

      @@name = 'android_app'
      @@uuid = '8d72d66c-0320-4861-8793-c5aebd195fc2'

      class << self

        def make_for app
          data = {}
          data['package'] = app.android_app_package if app.android_app_package
          data['scheme'] = app.android_app_scheme if app.android_app_scheme
          data['action'] = app.android_app_action if app.android_app_action
          data['category'] = app.android_app_category if app.android_app_category
          data['component'] = app.android_app_component if app.android_app_component
          data.keys.length > 0 ? data : nil
        end

      end

    end
  end
end
