module Casa
  module Attribute
    class Tags

      cattr_reader :name, :uuid

      @@name = 'tags'
      @@uuid = 'c6e33506-b170-475b-83e9-4ecd6b6dd42a'

      class << self

        def make_for app
          app.app_tags.map(){ |c| c.name }
        end

      end

    end
  end
end
