class CreateAppLtiVersions < ActiveRecord::Migration
  def change
    create_table :app_lti_versions do |t|

      t.references :app
      t.string :version

      t.index :version

    end
  end
end
