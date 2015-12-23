class UpdateAppsAddWcagUrl < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :wcag_url
    end
  end
end
