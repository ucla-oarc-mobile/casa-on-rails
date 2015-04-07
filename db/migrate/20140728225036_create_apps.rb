class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :title, index: true
      t.text :uri
      t.text :icon
      t.text :description
      t.boolean :share, default: true, index: true
      t.boolean :propagate, default: true, index: true

      t.timestamps
    end
  end
end
