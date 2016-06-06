class AddReviewStatusColumnsToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.integer :overall_review_status
      t.integer :privacy_review_status
      t.integer :security_review_status
      t.integer :accessibility_review_status
    end
  end
end
