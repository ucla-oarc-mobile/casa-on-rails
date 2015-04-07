class CreateAppBrowserFeatures < ActiveRecord::Migration
  def change
    create_table :app_browser_features do |t|

      t.references :app
      t.string :feature
      t.string :level

      t.index :feature
      t.index :level

    end
  end
end
