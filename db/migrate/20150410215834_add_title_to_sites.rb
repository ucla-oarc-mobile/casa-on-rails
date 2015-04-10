class AddTitleToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.string :title, default: nil

    end
  end
end
