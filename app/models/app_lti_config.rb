class AppLtiConfig < ActiveRecord::Base

  belongs_to :app
  validates :lti_launch_url, presence: true

end
