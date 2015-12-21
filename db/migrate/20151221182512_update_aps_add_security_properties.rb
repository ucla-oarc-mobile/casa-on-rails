class UpdateApsAddSecurityProperties < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.boolean :security_uses_https
      t.boolean :security_uses_additional_encryption
      t.boolean :security_requires_cookies
      t.boolean :security_requires_third_party_cookies
      t.boolean :security_sets_local_data
      t.string  :security_session_lifetime
      t.string  :security_cloud_vendor
      t.string  :security_policy_url
      t.string  :security_sla_url
      t.text    :security_text
    end
  end
end
