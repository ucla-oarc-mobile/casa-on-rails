class UpdateAppsAddSupportContact < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :support_contact_name, null: true
      t.string :support_contact_email, null: true
    end
  end
end
