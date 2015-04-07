class AddMobileSupportToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :mobile_support, default: false

    end
  end
end
