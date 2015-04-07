class CreateAppLaunchMethods < ActiveRecord::Migration
  def change
    create_table :app_launch_methods do |t|

      t.references :app
      t.string :method
      t.timestamps

    end
  end
end
