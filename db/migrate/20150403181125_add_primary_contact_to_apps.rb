class AddPrimaryContactToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.string :primary_contact_name, default: nil
      t.string :primary_contact_email, default: nil

    end
  end
end
