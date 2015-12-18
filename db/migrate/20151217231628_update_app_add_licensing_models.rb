class UpdateAppAddLicensingModels < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.boolean :license_is_free
      t.boolean :license_is_paid
      t.boolean :license_is_recharge
      t.boolean :license_is_by_seat
      t.boolean :license_is_subscription
      t.boolean :license_is_ad_supported
      t.boolean :license_is_other
      t.text :license_text
    end
  end
end
