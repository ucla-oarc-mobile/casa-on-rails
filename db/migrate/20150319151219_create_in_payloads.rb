class CreateInPayloads < ActiveRecord::Migration
  def change
    create_table :in_payloads do |t|

      t.string :casa_originator_id
      t.string :casa_id
      t.datetime :casa_timestamp
      t.references :in_peer
      t.references :app
      t.text :content
      t.timestamps
      t.datetime :deleted_at

      t.index [:casa_originator_id, :casa_id]
      t.index :casa_timestamp

    end
  end
end
