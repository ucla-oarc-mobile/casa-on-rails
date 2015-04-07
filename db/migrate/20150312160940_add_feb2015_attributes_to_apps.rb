class AddFeb2015AttributesToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.references :app_privacy_policy, null: true
      t.text :privacy_url, null: true
      t.text :accessibility_url, null: true
      t.text :vpat_url, null: true
      t.text :acceptable, null: true
      t.text :lti_configuration_url, null: true
      t.text :lti_registration_url, null: true
      t.string :lti_outcomes, null: true
      t.text :ios_app_id, null: true
      t.text :ios_app_scheme, null: true
      t.text :ios_app_path, null: true
      t.text :ios_app_affiliate_data, null: true
      t.text :android_app_package, null: true
      t.text :android_app_scheme, null: true
      t.text :android_app_action, null: true
      t.text :android_app_category, null: true
      t.text :android_app_component, null: true

    end
  end
end
