class EnlargeContentForInPayloads < ActiveRecord::Migration
  def change
    change_column :in_payloads, :content, :mediumtext
    change_column :in_payloads, :original_content, :mediumtext
  end
end
