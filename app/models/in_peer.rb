require 'uri'
require 'net/http'
require 'validators/uri_validator'

class InPeer < ActiveRecord::Base
  has_many :in_filter_rulesets

  validates :uri, uri: true

  def get_payloads

    uri = URI(self.uri)
    payloads = nil

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'

    request = Net::HTTP::Get.new uri

    request.add_field('Accept', 'application/json')
    request.add_field('Accept-Charset', 'utf-8')
    request.add_field('Content-Type', 'application/json')

    data = {
      'requestor_id' => Rails.application.config.casa[:engine][:uuid]
    }

    if self.secret
      data['secret'] = self.secret
    end

    request.body = data.to_json

    response = http.request(request)
    payloads = JSON.parse response.body

    payloads

  end

  after_save do
    PayloadRetriever.get_payloads(self)
  end

end
