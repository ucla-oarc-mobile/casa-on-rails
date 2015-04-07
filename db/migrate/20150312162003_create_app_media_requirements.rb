class CreateAppMediaRequirements < ActiveRecord::Migration
  def change
    create_table :app_media_requirements do |t|

      t.references :app
      t.boolean :color, null: true
      t.string :max_aspect_ratio, null: true
      t.string :max_color, null: true
      t.string :max_device_height, null: true
      t.string :max_device_width, null: true
      t.string :max_height, null: true
      t.string :max_resolution, null: true
      t.string :max_width, null: true
      t.string :min_aspect_ratio, null: true
      t.string :min_color, null: true
      t.string :min_device_height, null: true
      t.string :min_device_width, null: true
      t.string :min_height, null: true
      t.string :min_resolution, null: true
      t.string :min_width, null: true

    end
  end
end
