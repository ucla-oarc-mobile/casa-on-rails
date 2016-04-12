module Casa
  module Attribute
    class StudentData

      cattr_reader :name, :uuid

      @@name = 'student_data'
      @@uuid = 'bf43cd9a-63d2-416e-bee7-02debe5e18c9'

      class << self

        def make_for app
          data = {}
          %i(stores_local_data requires_account has_opt_out_for_data_collection has_opt_in_for_data_collection
             shows_eula is_app_externally_hosted stores_pii).each do |field|
            field_data = app.public_send("student_data_#{field.to_s}".to_sym)
            data[field] = field_data unless field_data.nil?
          end
          data
        end

      end

    end
  end
end
