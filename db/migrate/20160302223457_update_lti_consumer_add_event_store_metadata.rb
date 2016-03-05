class UpdateLtiConsumerAddEventStoreMetadata < ActiveRecord::Migration
  def change
    change_table :lti_consumers do |t|
      t.text :event_store_url
      t.string :event_store_api_key
    end
  end
end
