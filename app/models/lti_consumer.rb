class LtiConsumer < ActiveRecord::Base
  validates_uniqueness_of :key
end
