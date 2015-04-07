class AddTransitContentToInPayloads < ActiveRecord::Migration
  def change
    change_table :in_payloads do |t|
      t.text :original_content, null: true
    end
  end
end
