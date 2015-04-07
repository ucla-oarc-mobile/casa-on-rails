class CreateSites < ActiveRecord::Migration
  def change

    create_table :sites do |t|

      t.text :heading
      t.text :css, 10.megabytes
      t.timestamps

    end

    Site.create heading: '<h1>CASA</h1><h2>App Store</h2>', css: ''

  end
end
