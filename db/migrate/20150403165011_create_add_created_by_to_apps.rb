class CreateAddCreatedByToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.integer :created_by, default: nil

    end
  end
end
