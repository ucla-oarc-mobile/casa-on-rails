class UpdateAppsAddSupportedLanguages < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :supported_languages, null: true
    end
  end
end
