class UpdateLtiConsumerAddUniqueKeyOnKey < ActiveRecord::Migration
  def change
    add_index :lti_consumers, [:key], :unique => true
  end
end
