class CreateOutPeers < ActiveRecord::Migration
  def change
    create_table :out_peers do |t|

      t.string :name, index: true
      t.string :address
      t.string :netmask
      t.string :secret
      t.timestamps

    end
  end
end
