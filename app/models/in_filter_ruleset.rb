class InFilterRuleset < ActiveRecord::Base

  belongs_to :in_peer

  scope :global, -> { where(in_peer_id: nil) }

  def rules_object
    JSON.parse self.rules
  end

  def rules_object= rules_object
    self.rules = rules_object.to_json
  end

end
