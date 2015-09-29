# Be sure to restart your server when you modify this file.

require 'elasticsearch'
require 'yaml'

config = {
	hosts: [
	  { host: 'localhost', port: 9200 }
	],
	index: 'apps'
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml").deep_symbolize_keys)
end

Rails.application.config.elasticsearch_client = Elasticsearch::Client.new(config)
Rails.application.config.elasticsearch_index = config[:index]

begin
  Rails.application.config.elasticsearch_client.ping
  App.drop_index!
  App.where(enabled: true).each { |app| app.add_to_index! }
rescue Faraday::ConnectionFailed => e
  puts "WARNING: Could not connect to Elasticsearch"
  Rails.application.config.elasticsearch_client = nil
rescue ActiveRecord::StatementInvalid => e
  puts "WARNING: Running without initializing index"
end