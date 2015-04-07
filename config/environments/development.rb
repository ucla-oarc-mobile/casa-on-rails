Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Community App Sharing Architecture configuration
  config.casa = {
    :engine => {
      :uuid => 'dd8c99e2-fe5b-4911-a815-73c17b46d3fc'
    }
  }

  config.caliper = {
    :event_store => {
      :url => 'http://requestb.in/1izaf181'
    }
  }

  # Local configuration
  config.store = {
    :user_contact => { :name => 'John Doe', :email => 'invalid@localhost' }
  }

  # Local development configuration of the Shibboleth OAuth2 provider.
  config.oauth2 = {
      :provider => {
          :shibboleth => {
              :enabled => true,
              :key => 'casa',
              :secret => 'asac',
              :properties => {
                  :site => 'http://localhost',
                  :authorize_url => '/shib-oauth2-bridge/public/oauth2/test-authorize',
                  :token_url => '/shib-oauth2-bridge/public/oauth2/access_token'
              },
              :routes => {
                  :get_user => '/shib-oauth2-bridge/public/oauth2/user'
              },
              :restrict_to => {
                  :eduPersonPrincipalName => [
                    # users by eduPersonPrincipalName that are allowed to submit apps
                  ],
                  :eduPersonScopedAffiliation => [
                    # eduPersonScopedAffiliations that are allowed to submit apps
                    'employee@ucla.edu'
                  ]
              }
          }
      }
  }

  config.login_route = [:session_oauth2_launch_url, :shibboleth]

end
