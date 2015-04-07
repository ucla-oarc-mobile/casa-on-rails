require 'oauth2/client'
require 'oauth2/provider_not_enabled'
require 'ostruct'

module OAuth2
  module Provider
    class Shibboleth

      def initialize access_token
        @access_token = access_token
      end

      def config
        self.class.config
      end

      def get_user
        data = JSON.parse(@access_token.get(config[:routes][:get_user]).body)
        OpenStruct.new({
          id: data['eduPersonPrincipalName'],
          data: {
            first_name: data['givenName'],
            last_name: data['sn'],
            email: data['mail']
          },
          eduPersonScopedAffiliation: data.include?('eduPersonScopedAffiliation') ? data['eduPersonScopedAffiliation'].split(";").map(&:strip) : []
        })
      end

      def user
        unless @user
          @user = get_user
        end
        @user
      end

      def allows_user?
        if config.include? :restrict_to
          if config[:restrict_to].include? :eduPersonPrincipalName
            eduPersonScopedAffiliations = config[:restrict_to][:eduPersonPrincipalName].is_a?(Array) ? config[:restrict_to][:eduPersonPrincipalName] : [config[:restrict_to][:eduPersonPrincipalName]]
            return true if eduPersonScopedAffiliations.include?(user.id)
          end
          if config[:restrict_to].include? :eduPersonScopedAffiliation
            eduPersonScopedAffiliations = config[:restrict_to][:eduPersonScopedAffiliation].is_a?(Array) ? config[:restrict_to][:eduPersonScopedAffiliation] : [config[:restrict_to][:eduPersonScopedAffiliation]]
            eduPersonScopedAffiliations.each do |eduPersonScopedAffiliation|
              return true if user.eduPersonScopedAffiliation.include?(eduPersonScopedAffiliation)
            end
          end
          return false
        else
          return true
        end
      end

      class << self

        def config
          Rails.application.config.oauth2[:provider][:shibboleth]
        end

        def client
          raise OAuth2::ProviderNotEnabled.new unless config[:enabled]
          OAuth2::Client.new config[:key], config[:secret], config[:properties]
        end

        def access_token code, properties
          self.client.auth_code.get_token(code, properties)
        end

        def new_with_authorization code, properties
          self.new(self.access_token(code, properties))
        end

      end

    end
  end
end