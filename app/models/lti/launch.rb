module Lti
  class Launch

    class << self

      def credentials
        data = {}
        LtiConsumer.all.each { |r| data[r.key] = r.secret }
        data
      end

    end

    attr_reader :credentials,
                :params,
                :request,
                :session,
                :tp,
                :error

    def initialize options

      @credentials = self.class.credentials
      @params = options[:params]
      @request = options[:request]
      @session = options[:session]
      @tp = nil
      @tp_metadata = nil
      @error = nil

      execute!

    end

    def save!
      if @error.nil?
        session['launch_params'] = @tp.to_params
        session['tp_metadata'] = @tp_metadata unless @tp_metadata.blank?
        @tp.to_params
      else
        false
      end
    end

    private

    def execute!

      if key = params['oauth_consumer_key']
        if credentials.include? key
          @tp = Lti::ContentItemToolProvider.new(key, credentials[key], params)

          # Grab any additional LTI Consumer metadata so it can be included in the ContentItemResponse
          # POST back to the TC.
          @tp_metadata = {}
          results = LtiConsumer.where(key: key).select('event_store_url', 'event_store_api_key', 'sso_type', 'sso_idp_url')
          results.map { |row|
            @tp_metadata['event_store_url'] = row.event_store_url unless row.event_store_url.blank?
            @tp_metadata['event_store_api_key'] = row.event_store_api_key unless row.event_store_api_key.blank?
            @tp_metadata['sso_type'] = row.sso_type unless row.sso_type.blank?
            @tp_metadata['sso_idp_url'] = row.sso_idp_url unless row.sso_idp_url.blank?
          }
        else
          @error = 403
          return false
        end
      else
        @error = 401
        return false
      end

      if !@tp.valid_request?(request)
        @error = 403
        Rails.logger.info "The OAuth signature was invalid"
        return false
      end

      if Time.now.utc.to_i - @tp.request_oauth_timestamp.to_i > 60*60
        @error = 400 # TODO: determine what the right code is for staleness
        return false
      end

      # this isn't actually checking anything like it should, just want people
      # implementing real tools to be aware they need to check the nonce
      if was_nonce_used_in_last_x_minutes?(@tp.request_oauth_nonce, 60)
        @error = 400 # TODO: determine what the right code is for staleness
        return false
      end

      return true

    end

    # TODO: implement nonce handling
    def was_nonce_used_in_last_x_minutes?(nonce, minutes=60)
      false
    end

  end
end