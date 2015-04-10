class AddHomepageCategoriesToSites < ActiveRecord::Migration
  def change
    change_table :sites do |t|

      t.text :homepage_categories, default: nil

    end
  end
end
