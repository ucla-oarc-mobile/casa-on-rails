module Casa
  module Attribute
    class Competencies

      cattr_reader :name, :uuid

      @@name = 'competencies'
      @@uuid = '4f51209d-780e-42b2-aeb6-d5cf942b86a3'

      class << self

        def make_for app
          app.app_competencies.map(){ |c| c.name }
        end

      end

    end
  end
end
