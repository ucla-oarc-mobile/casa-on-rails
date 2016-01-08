class UpdateLtiAttribute < ActiveRecord::Migration
  def up

    # Create the new LTI Table
    create_table :app_lti_configs do |t|
      t.references :app
      t.string :lti_launch_url
      t.text :lti_launch_params
      t.string :lti_registration_url
      t.string :lti_configuration_url
      t.text :lti_content_item_message
      t.string :lti_lis_outcomes
      t.string :lti_version
      t.string :lti_ims_global_registration_number
      t.string :lti_ims_global_conformance_date
      t.string :lti_ims_global_registration_link
      t.timestamps
    end

    # Grab all of the existing data and add it to the new table. Use a left join because not every LTI app
    # will have an LTI version.
    results = execute 'select apps.id, app_lti_versions.version, apps.lti_launch_url, apps.lti_registration_url, apps.lti_configuration_url, apps.lti_outcomes' +
                      ' from apps left join app_lti_versions on apps.id = app_lti_versions.app_id' +
                      ' where lti = 1'
                      ' order by apps.id, app_lti_versions.version;'

    puts 'ID, LTI Version'

    # current_id = nil
    # current_version = nil

    results.each do | row |
      # In the old model, one LTI config was allowed to have many LTI versions. In the new model, the config is bound
      # to the version so any old config with multiple versions will be stored in multiple rows now.

      puts 'Adding new row to app_lti_configs with app ID and LTI Version: '+ row[0].to_s + ', ' + row[1].to_s

      AppLtiConfig.create({app_id: row[0], lti_version: row[1], lti_launch_url: row[2], lti_registration_url: row[3], lti_configuration_url: row[4], lti_lis_outcomes: row[5] })
    end

    drop_table :app_lti_versions
    remove_column :apps, :lti_launch_url
    remove_column :apps, :lti_registration_url
    remove_column :apps, :lti_outcomes
    remove_column :apps, :lti_configuration_url

  end

  def down

    # Add the old table and columns back
    create_table :app_lti_versions do |t|
      t.references :app
      t.string :version

      t.index :version
    end

    add_column :apps, :lti_launch_url, :string
    add_column :apps, :lti_registration_url, :string
    add_column :apps, :lti_configuration_url, :string
    add_column :apps, :lti_outcomes, :string

    # Add the data back
    results = execute 'select app_id, launch_url, registration_url, configuration_url, lis_outcomes, version from app_lti_configs;'
    current_id = nil

    results.each do | row |
      # Avoid updating the apps table multiple times even though we would be using the same data based on the undo
      # action currently being performed.
      if current_id != row[0]
        current_id = row[0];

        App.update(row[0], lti_launch_url: row[1], lti_registration_url: row[2], lti_configuration_url: row[3], lti_outcomes: row[4])
      end

      AppLtiVersion.create({app_id: row[0], version: row[5]})

    end

    # Drop the new table
    drop_table :app_lti_configs

  end

end
