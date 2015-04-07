require 'ims/lti'

module Lti
  module ContentItemLaunchParams

    # List of the standard launch parameters for an LTI launch
    CONTENT_ITEM_LAUNCH_DATA_PARAMETERS = %w{
      accept_media_types
      accept_presentation_document_targets
      content_item_return_url
      accept_unsigned
      accept_multiple
      accept_copy_advice
      text
      title
      data
    }

    CONTENT_ITEM_LAUNCH_DATA_PARAMETERS.each { |p| attr_accessor p }

    def content_item_launch_data_hash
      CONTENT_ITEM_LAUNCH_DATA_PARAMETERS.inject({}) { |h, k| h[k] = self.send(k) if self.send(k); h }
    end

  end
end