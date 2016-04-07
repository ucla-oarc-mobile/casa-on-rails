require 'validators/uri_validator'

class LtiConsumer < ActiveRecord::Base
  validates_uniqueness_of :key
  validates :event_store_url, uri: true
end
