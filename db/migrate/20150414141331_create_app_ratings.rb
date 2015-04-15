class CreateAppRatings < ActiveRecord::Migration
  def change
    create_table :app_ratings do |t|

      t.references :app
      t.references :user
      t.integer :score, default: nil
      t.text :review, default: nil
      t.timestamps

    end
  end
end
