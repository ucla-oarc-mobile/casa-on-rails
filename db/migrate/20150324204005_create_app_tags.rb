class CreateAppTags < ActiveRecord::Migration
  def change
    create_table :app_tags do |t|

      t.references :app
      t.string :name
      t.timestamps

    end
  end
end
