require 'yaml'

# Caliper Endpoint
# This is a fake default endpoint.
config = {
  :caliper => {
    :event_store => {
        :url => 'http://example.com',
        :api_key => 'secret',
        :sensor_id => '89535BAA-F345-45C0-9851-5E08FC1C0122'
    }
  }
}

# Override with YAML
if File.exists?('config/caliper.yml')
  config.merge!(YAML.load_file('config/caliper.yml').deep_symbolize_keys)
end

Rails.application.config.caliper = config[:caliper]



