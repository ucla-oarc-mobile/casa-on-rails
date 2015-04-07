class CreateAppAuthors < ActiveRecord::Migration
  def change
    create_table :app_authors do |t|
      t.belongs_to :app
      t.string :name
      t.string :email
      t.string :website
    end
  end
end
