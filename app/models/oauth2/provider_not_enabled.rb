module OAuth2
  class ProviderNotEnabled < RuntimeError
    def initialize
      super 'Shibboleth is not enabled in config.oauth2.provider.shibboleth'
    end
  end
end