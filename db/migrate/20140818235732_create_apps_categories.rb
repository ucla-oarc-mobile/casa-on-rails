class CreateAppsCategories < ActiveRecord::Migration
  def change
    create_table :apps_categories do |t|
      t.belongs_to :app
      t.belongs_to :category
    end
  end
end
