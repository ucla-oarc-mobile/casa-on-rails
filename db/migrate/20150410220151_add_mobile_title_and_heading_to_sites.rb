class AddMobileTitleAndHeadingToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.string :mobile_title, default: nil
      t.text :mobile_heading, default: nil

    end
  end
end
