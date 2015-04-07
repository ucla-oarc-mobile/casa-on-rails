class UpdateAppsAddEnabled < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.boolean :enabled, default: false, index: true, after: 'description'
    end
  end
end
