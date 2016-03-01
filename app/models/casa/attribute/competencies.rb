module Casa
  module Attribute
    class Competencies

      cattr_reader :name, :uuid

      @@name = 'competencies'
      @@uuid = 'dbc9751f-be5d-4508-8dee-4acc9e3babe5'

      class << self

        def make_for app
          app.app_competencies.map(){ |c| c.name }
        end

      end

    end
  end
end
