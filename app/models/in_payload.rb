class InPayload < ActiveRecord::Base

  belongs_to :in_peer

  def content_data
    @content_data ||= JSON.parse content
  end

  def title
    begin
      content_data['attributes']['require']['title'] || content_data['attributes']['use']['title']
    rescue
      'Untitled'
    end
  end

  def related_app
    unless defined? @related_app
      @related_app = App.where(casa_id: casa_id, casa_originator_id: casa_originator_id).first
    end
    @related_app
  end

end
