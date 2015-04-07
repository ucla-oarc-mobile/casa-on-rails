require 'ims/lti'
require 'json'
require 'oauth'
require 'oauth/request_proxy/rack_request'
require 'securerandom'

# ContentItem-supporting tool provider. Note that this only provides the functions needed by
# this application, and it should not be used as a reference for complete conformace to the
# ContentItem spec.
module Lti
  class ContentItemToolProvider < ::IMS::LTI::ToolProvider

    include Lti::ContentItemLaunchParams

    attr_accessor :content_item_requests

    def initialize(consumer_key, consumer_secret, params={})
      super(consumer_key, consumer_secret, params)
      @content_item_requests = []
    end

    def content_item_selection_request?
      lti_message_type == 'ContentItemSelectionRequest'
    end

    def to_params
      content_item_launch_data_hash.merge super
    end

    def process_params(params)
      super(params)
      params.each_pair do |key, val|
        if CONTENT_ITEM_LAUNCH_DATA_PARAMETERS.member?(key)
          self.send("#{key}=".to_sym, val)
        end
      end
    end

    def has_required_attributes?
      @consumer_key && @consumer_secret && @content_item_return_url
    end

    def generate_content_item_response_parameters content_items

      content_items = [content_items] unless content_items.is_a? Array

      content_items_parameter = {
          '@context' => 'http://purl.imsglobal.org/ctx/lti/v1/ContentItem',
          '@graph' => []
      }

      content_items.each do |content_item|
        content_items_parameter['@graph'].push({
          '@type' => 'LtiLink',
          'placementAdvice' => {
              'presentationDocumentTarget' => 'window'
          }
        }.merge(content_item))
      end

      parameters = {
          'content_items' => content_items_parameter.to_json,
          'lti_message_type' => 'ContentItemSelection',
          'lti_version' => 'LTI-1p0',
          'oauth_callback' => self.oauth_callback,
          'oauth_consumer_key' => self.oauth_consumer_key,
          'oauth_nonce' => SecureRandom.hex,
          'oauth_signature_method' => self.oauth_signature_method,
          'oauth_timestamp' => Time.now.to_i,
          'oauth_version' => self.oauth_version
      }

      query_string_parameters = URI(self.content_item_return_url).query
      if query_string_parameters
        URI.decode_www_form(query_string_parameters).each do |component|
          parameters[component[0]] = component[1]
        end
      end

      parameters = Hash[parameters.sort]

      consumer = OAuth::Consumer.new(self.consumer_key, self.consumer_secret)
      token = OAuth::AccessToken.new(consumer) # TODO: why if we don't do anything with it?

      req = OAuth::RequestProxy.proxy({
        'parameters'=>parameters,
        'method'=>'POST',
        'uri'=>self.content_item_return_url_without_query_string
      })

      parameters['oauth_signature'] = req.sign({
        :consumer => consumer,
        :signature_method => self.oauth_signature_method
      })

      parameters

    end

    def content_item_return_url_without_query_string
      content_item_return_url[/[^\?]+/]
    end

    class << self

      def new_from_launch_params options

        return nil unless options[:session].include?('launch_params')
        launch_params = options[:session]['launch_params']

        return nil unless launch_params.include?('oauth_consumer_key')
        key = launch_params['oauth_consumer_key']

        return nil unless Lti::Launch.credentials.include?(key)
        secret = Lti::Launch.credentials[key]

        self.new(key, secret, launch_params)

      end

      def destroy_launch! options
        options[:session].delete('launch_params')
      end

    end

  end
end