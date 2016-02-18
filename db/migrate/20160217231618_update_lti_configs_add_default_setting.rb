class UpdateLtiConfigsAddDefaultSetting < ActiveRecord::Migration
  def change
    change_table :app_lti_configs do |t|
      t.boolean :lti_default
    end
  end
end
