class CreateLtiConsumers < ActiveRecord::Migration
  def change
    create_table :lti_consumers do |t|

      t.string :name
      t.string :key
      t.string :secret
      t.timestamps

    end
  end
end
