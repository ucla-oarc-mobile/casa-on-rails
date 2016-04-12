module Casa
  module Attribute
    class AdminContact

      cattr_reader :name, :uuid

      @@name = 'admin_contact'
      @@uuid = '6f5f980d-c95a-4cd1-ae87-0c55d9cb6ec6'

      class << self

        def make_for app
          data = {}
          data['name'] = app.primary_contact_name if app.primary_contact_name
          data['email'] = app.primary_contact_email if app.primary_contact_email
          data
        end

      end

    end
  end
end
