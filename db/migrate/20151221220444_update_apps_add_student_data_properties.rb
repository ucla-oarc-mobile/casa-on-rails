class UpdateAppsAddStudentDataProperties < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.boolean :student_data_requires_account
      t.boolean :student_data_has_opt_out_for_data_collection
      t.boolean :student_data_has_opt_in_for_data_collection
      t.boolean :student_data_shows_eula
      t.boolean :student_data_is_app_externally_hosted
      t.boolean :student_data_stores_pii
      # see also the rename column in the previous migration
    end

  end
end
