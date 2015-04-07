class UpdateAppsAddCasaInPayload < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.text :casa_in_payload, null: true
    end
  end
end
