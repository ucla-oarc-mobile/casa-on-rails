class AddSharingPreferencesToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.string :sharing_preference, default: nil

    end
  end
end
