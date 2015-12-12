class AddCaliperAttributePropertiesToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|

      t.boolean :caliper, default: false

      # For now, we are storing JSON instead of normalizing the data out into separate relations.

      # A JSON object composed of a JSON array of JSON objects that are Caliper metric profile declarations.
      # http://imsglobal.github.io/casa-protocol/#Attributes/Interoperability:caliper
      t.text :caliper_metric_profiles, default: nil

      # A JSON object composed of a JSON array of JSON objects that are Caliper certifications from IMS Global.
      # The certifications are separated from the metric profiles because not all profiles will be certified.
      t.text :caliper_ims_global_certifications, default: nil

    end
  end
end
