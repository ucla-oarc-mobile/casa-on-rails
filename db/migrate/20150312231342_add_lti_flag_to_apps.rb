class AddLtiFlagToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :lti, default: false

    end
  end
end
