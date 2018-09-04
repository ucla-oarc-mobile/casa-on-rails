module Casa
  module Attribute
    class PrivacyUrl

      cattr_reader :name, :uuid

      @@name = 'privacy_url'
      @@uuid = '1d5b3bbe-5715-4064-adb8-65209eeda3fe'

      class << self
        def make_for app
          # This wonky code is needed because the Elasticsearch init code
          # is dumb and tries to call it before the routes are set up
          if Rails.application.routes.url_helpers.respond_to?(:privacy_app_url)
            Rails.application.routes.url_helpers.privacy_app_url(app)
          else
            ""
          end
        end
      end
    end
  end
end
