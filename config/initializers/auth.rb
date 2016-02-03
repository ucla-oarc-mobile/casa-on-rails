require 'yaml'

# Default local login path.
Rails.application.config.login_route = [:session_url]

# Include the auth configuration if it exists, otherwise the app will use the default login.
if File.exists?('config/auth.yml')
  config = YAML.load_file('config/auth.yml').deep_symbolize_keys

  Rails.application.config.oauth2 = config[:oauth2]
  Rails.application.config.login_route = config[:login_route]
end

