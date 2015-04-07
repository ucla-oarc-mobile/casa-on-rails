class AddOfficialToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :official, default: false

    end
  end
end
