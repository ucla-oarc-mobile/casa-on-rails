module Validators
  class URIValidator < ActiveModel::Validator
    def validate(record)
      if record.uri
        u = URI(record.uri)
        record.errors[:base] << 'The URL must begin with a scheme (http:// or https://).' unless u.host && u.scheme
      else
        record.errors[:base] << 'A URL is required.'
      end
    end
  end
end