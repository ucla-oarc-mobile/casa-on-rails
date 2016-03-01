module Casa
  module Attribute
    class SupportContact

      cattr_reader :name, :uuid

      @@name = 'support_contact'
      @@uuid = '2536a700-f91c-4f16-a298-cfef43aba3d1'

      class << self

        def make_for app
          data = {}
          data['support_contact_name'] = app.support_contact_name if app.support_contact_name
          data['support_contact_email'] = app.support_contact_email if app.support_contact_email
          data
        end

      end

    end
  end
end
