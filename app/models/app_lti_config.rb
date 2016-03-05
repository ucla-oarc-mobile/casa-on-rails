require 'validators/simple_json_validator'

class AppLtiConfig < ActiveRecord::Base

  validates :lti_launch_url, presence: true
  validates :lti_content_item_message, simple_json: true

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end

end
