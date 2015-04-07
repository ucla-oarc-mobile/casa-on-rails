class UpdateAppsAddCasaIdentity < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :casa_id, null: true
      t.string :casa_originator_id, null: true
    end
  end
end
