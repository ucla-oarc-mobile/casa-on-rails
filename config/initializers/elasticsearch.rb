# Be sure to restart your server when you modify this file.

require 'elasticsearch'

Rails.application.config.elasticsearch_client = Elasticsearch::Client.new hosts: [
  { host: 'localhost', port: 9200 }
]

Rails.application.config.elasticsearch_index = 'apps'

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