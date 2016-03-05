 class SimpleJsonValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value
        begin
          JSON.parse value
        rescue
          record.errors[attribute] << ' must be well-formed JSON.'
        end
      end
    end
  end
