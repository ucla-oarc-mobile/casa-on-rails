class RemoveRedundantLtiUrlFromLtiConfigs < ActiveRecord::Migration
  def change
    remove_column :app_lti_configs, :lti_url_for_oauth_consumer_key_and_secret
  end
end
