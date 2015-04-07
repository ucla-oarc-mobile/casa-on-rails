class AddMobileAppiconToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.text :mobile_appicon, default: nil

    end
  end
end
