class CreateAppFeatures < ActiveRecord::Migration
  def change
    create_table :app_features do |t|
        t.references :app
        t.string :feature_name
        t.timestamps
    end
  end
end
