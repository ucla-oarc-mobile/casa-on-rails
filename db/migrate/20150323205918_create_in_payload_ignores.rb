class CreateInPayloadIgnores < ActiveRecord::Migration
  def change
    create_table :in_payload_ignores do |t|

      t.string :casa_originator_id
      t.string :casa_id
      t.timestamps

      t.index [:casa_originator_id, :casa_id]

    end
  end
end
