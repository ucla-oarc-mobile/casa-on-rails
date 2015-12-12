# Reusable logic for manipulating CASA Attribute data.

require 'json-schema'

module AttributeConcern
  extend ActiveSupport::Concern

  def fully_validate_against_json_schema(schema_file, data)

    error_text = JSON::Validator.fully_validate(schema_file, data)

    if error_text.nil? or error_text.empty?

      # Disallow the empty JSON Object which always passes JSON schema validation.
      # At this point, we know we have valid JSON so there is no guard around the parse here.
      if JSON.parse(data).empty?
        error_text = ['The provided JSON Object was empty.']
      end

    end

    error_text

  end

end