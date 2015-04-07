class AddShortDescriptionToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :short_description, null: true
    end
  end
end
