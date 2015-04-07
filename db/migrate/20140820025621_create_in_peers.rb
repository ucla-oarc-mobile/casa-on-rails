class CreateInPeers < ActiveRecord::Migration
  def change
    create_table :in_peers do |t|
      t.string :name, index: true
      t.text :uri
      t.string :secret

      t.timestamps
    end
  end
end
