require 'yaml'

# Community App Sharing Architecture configuration

config = {
    # This is the instance's originator_id. It should always be overridden using
    # the YAML configuration.
    casa: { engine: { uuid: 'dd8c99e2-fe5b-4911-a815-73c17b46d3fc'} },
    # Contact metadata for the storefront
    store: { user_contact: { name: 'John Doe', email: 'invalid@localhost'} }
}

# Override with YAML
if File.exists?('config/casa.yml')
  Rails.application.config.merge!(YAML.load_file('config/casa.yml').deep_symbolize_keys)
end

Rails.application.config.casa = config[:casa]

Rails.application.config.store = config[:store]
