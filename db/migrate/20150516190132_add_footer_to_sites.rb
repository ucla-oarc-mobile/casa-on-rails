class AddFooterToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.text :footer, default: nil

    end
  end
end
