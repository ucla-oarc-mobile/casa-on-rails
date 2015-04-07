class CreateInFilterRulesets < ActiveRecord::Migration
  def change
    create_table :in_filter_rulesets do |t|

      t.references :in_peer # null if applicable to all InPeers
      t.text :rules
      t.timestamps

    end
  end
end
