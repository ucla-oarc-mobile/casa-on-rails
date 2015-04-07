class AddCasaIdToInPeers < ActiveRecord::Migration
  def change
    change_table :in_peers do |t|
      t.string :casa_id, null: true
    end
  end
end
