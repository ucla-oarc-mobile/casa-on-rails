module Casa
  module Attribute
    class WcagGuidelines

      cattr_reader :name, :uuid

      @@name = 'wcag_guidelines'
      @@uuid = '398ad595-b2cd-44c4-8864-921f4f25536b'

      class << self

        def make_for app
          app.app_wcag_guidelines.map(){ |g| g.guideline }
        end

      end

    end
  end
end
