class AddLtiConsumerIdToLtiConfigs < ActiveRecord::Migration
  def change
    change_table :app_lti_configs do |t|
      t.belongs_to :lti_consumer
    end
  end
end
