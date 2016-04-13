class AddSsoPropertiesToLtiConsumers < ActiveRecord::Migration
  def change
    change_table :lti_consumers do |t|
      t.string :sso_type
      t.string :sso_idp_url
    end
  end
end
