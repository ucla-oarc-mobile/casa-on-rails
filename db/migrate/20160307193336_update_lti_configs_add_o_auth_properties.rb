class UpdateLtiConfigsAddOAuthProperties < ActiveRecord::Migration
  def change
    change_table :app_lti_configs do |t|
      t.text :lti_oauth_consumer_key
      t.text :lti_oauth_consumer_secret
      t.text :lti_url_for_oauth_consumer_key_and_secret
    end
  end
end
