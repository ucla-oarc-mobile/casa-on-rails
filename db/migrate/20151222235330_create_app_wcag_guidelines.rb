class CreateAppWcagGuidelines < ActiveRecord::Migration
  def change
    create_table :app_wcag_guidelines do |t|
      t.references :app
      t.string :guideline
      t.timestamps
    end
  end
end
