class AddUniqueIndexToAppLtiConfigs < ActiveRecord::Migration
  def change
    add_index :app_lti_configs, [:app_id, :lti_consumer_id], :unique => true
  end
end
