class InPayload < ActiveRecord::Base

  belongs_to :in_peer

  def content_data
    @content_data ||= JSON.parse content
  end

  def title
    title = nil
    if content_data['attributes'].has_key?('require')
      title = content_data['attributes']['require']['title']
    end
    if title == nil
      if content_data['attributes'].has_key?('use')
        title = content_data['attributes']['use']['title']
      end
    end
    if title == nil
      title = 'Untitled'
    end
    title
  end

  def related_app
    unless defined? @related_app
      @related_app = App.where(casa_id: casa_id, casa_originator_id: casa_originator_id).first
    end
    @related_app
  end

end
