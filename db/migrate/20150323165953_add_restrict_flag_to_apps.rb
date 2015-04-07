class AddRestrictFlagToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :restrict, default: false

    end
  end
end
