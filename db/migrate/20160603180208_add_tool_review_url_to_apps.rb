class AddToolReviewUrlToApps < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.string :tool_review_url
    end
  end
end
