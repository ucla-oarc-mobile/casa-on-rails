class CreateAppOutPeerPermissions < ActiveRecord::Migration
  def change
    create_table :app_out_peer_permissions do |t|

      t.references :app
      t.references :out_peer
      t.timestamps

    end
  end
end
