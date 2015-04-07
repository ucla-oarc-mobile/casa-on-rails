class AddUniqueKeyToInPayloads < ActiveRecord::Migration
  def change
    change_table :in_payloads do |t|

      t.index [:casa_originator_id, :casa_id, :casa_timestamp], unique: true, name: 'uniq_casa_payload_id'

    end
  end
end
