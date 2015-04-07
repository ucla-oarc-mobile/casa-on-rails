class AddRestrictLaunchToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :restrict_launch, default: false

    end
  end
end
