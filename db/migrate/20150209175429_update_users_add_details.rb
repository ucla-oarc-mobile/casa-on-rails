class UpdateUsersAddDetails < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :first_name, index: true, after: 'admin'
      t.string :last_name, index: true, after: 'first_name'
      t.string :email, index: true, after: 'last_name'
    end
  end
end
