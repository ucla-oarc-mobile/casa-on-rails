class AddLtiLaunchUrlToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.text :lti_launch_url, null: true

    end
  end
end
