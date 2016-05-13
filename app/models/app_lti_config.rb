require 'validators/simple_json_validator'
require 'validators/uri_validator'

class AppLtiConfig < ActiveRecord::Base
  include ActiveModel::Validations

  class LtiUrlForVersionValidator < ActiveModel::Validator
    def validate(record)
      if record.lti_version != '2.0'
        record.errors.add(:lti_launch_url, ' is required for LTI 1.x.') if record.lti_launch_url.blank?
        record.errors.add(:lti_registration_url, ' is not allowed for LTI 1.x.') if record.lti_registration_url.present?
      else
        record.errors.add(:lti_registration_url, ' is required for LTI 2.0.') if record.lti_registration_url.blank?
        record.errors.add(:lti_launch_url, ' is not allowed for LTI 2.0.') if record.lti_launch_url.present?
        if record.lti_oauth_consumer_key.present? or record.lti_oauth_consumer_secret.present?
          record.errors.add(:oauth, ' - the OAuth values cannot be set for LTI 2.0. They should only be available at the Registration URL.')
        end
      end

    end
  end

  validates :lti_launch_url, uri: true
  validates :lti_registration_url, uri: true
  validates :lti_configuration_url, uri: true

  validates :lti_content_item_message, simple_json: true

  validates_with LtiUrlForVersionValidator

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end

end
