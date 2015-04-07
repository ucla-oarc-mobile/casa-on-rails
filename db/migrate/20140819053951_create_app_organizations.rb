class CreateAppOrganizations < ActiveRecord::Migration
  def change
    create_table :app_organizations do |t|
      t.belongs_to :app
      t.string :name
      t.string :website
    end
  end
end
