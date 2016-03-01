module Casa
  module Attribute
    class StudentData

      cattr_reader :name, :uuid

      @@name = 'student_data'
      @@uuid = 'bf43cd9a-63d2-416e-bee7-02debe5e18c9'

      class << self

        def make_for app
          data = {}
          %i(student_data_stores_local_data student_data_requires_account student_data_has_opt_out_for_data_collection
             student_data_has_opt_in_for_data_collection student_data_shows_eula student_data_is_app_externally_hosted
             student_data_stores_pii).each do |field|
            data[field] = app.public_send(field) if app.public_send(field)
          end
          data
        end

      end

    end
  end
end
