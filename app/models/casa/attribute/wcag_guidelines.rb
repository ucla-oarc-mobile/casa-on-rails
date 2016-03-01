module Casa
  module Attribute
    class WcagGuidelines

      cattr_reader :name, :uuid

      @@name = 'wcag_guidelines'
      @@uuid = '17abad98-039c-4b21-a60c-40ac71601faa'

      class << self

        def make_for app
          app.app_wcag_guidelines.map(){ |g| g.guideline }
        end

      end

    end
  end
end
