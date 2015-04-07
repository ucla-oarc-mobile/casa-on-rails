class CreateOauth2Identities < ActiveRecord::Migration
  def change
    create_table :oauth2_identities do |t|

      t.string :provider, null: false
      t.string :provider_user_id, null: false
      t.references :user, index: true, null: true
      t.timestamps

      t.index [:provider, :provider_user_id], :unique => true, :name => 'provider_compound_key'

    end
  end
end
