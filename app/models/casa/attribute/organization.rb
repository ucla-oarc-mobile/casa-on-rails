module Casa
  module Attribute
    class Organization

      cattr_reader :name, :uuid

      @@name = 'organization'
      @@uuid = '273c148d-de83-499e-b554-4cac9b262ab6'

      class << self

        def make_for app
          app.app_organizations.map do |o|
            data = { 'name' => o.name }
            data['website'] = o.website if o.website
            data
          end
        end

      end

    end
  end
end
