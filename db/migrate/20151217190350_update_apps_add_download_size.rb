class UpdateAppsAddDownloadSize < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :download_size, null: true
    end
  end
end
