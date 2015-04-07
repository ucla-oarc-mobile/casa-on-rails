module Casa
  module Attribute
    class Author

      cattr_reader :name, :uuid

      @@name = 'author'
      @@uuid = 'd59e3a1f-c034-4309-a282-60228089194e'

      class << self

        def make_for app
          app.app_authors.map do |c|
            data = { 'name' => c.name }
            data['email'] = c.email if c.email
            data['website'] = c.website if c.website
            data
          end
        end

      end

    end
  end
end
