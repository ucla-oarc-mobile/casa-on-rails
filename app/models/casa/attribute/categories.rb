module Casa
  module Attribute
    class Categories

      cattr_reader :name, :uuid

      @@name = 'categories'
      @@uuid = 'c80df319-d5da-4f59-8ca3-c89b234c5055'

      class << self

        def make_for app
          app.categories.map(){ |c| c.name }
        end

      end

    end
  end
end
