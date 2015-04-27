class AddMobileFooterToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.text :mobile_footer, default: nil

    end
  end
end
