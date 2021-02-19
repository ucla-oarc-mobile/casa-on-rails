require 'yaml'
require 'omniauth-keycloak'

# Default local login path.
Rails.application.config.login_route = '/session'

# Include the auth configuration if it exists, otherwise the app will use the default login.
if File.exists?('config/auth.yml')
  OmniAuth.config.logger = Rails.logger

  config = YAML.load_file('config/auth.yml').deep_symbolize_keys

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider(*config[:omniauth])
  end

  Rails.application.config.login_route = config[:login_route]
end
