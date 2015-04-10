class AddDefaultMobileAppToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.integer :default_app_order, default: nil

    end
  end
end
