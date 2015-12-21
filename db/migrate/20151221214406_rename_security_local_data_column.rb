class RenameSecurityLocalDataColumn < ActiveRecord::Migration
  def change
    rename_column :apps, :security_sets_local_data, :student_data_stores_local_data
  end
end
