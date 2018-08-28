class AddPrivacyTextToApps < ActiveRecord::Migration
  def change
    add_column :apps, :privacy_text, :text
  end
end
