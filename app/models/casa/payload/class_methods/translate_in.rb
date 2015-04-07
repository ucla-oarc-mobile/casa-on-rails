module Casa
  class Payload
    module ClassMethods
      module TranslateIn

        def translate_in payload

          payload['original'] = translate_in_attributes_section payload['original']

          if payload.include? 'attributes'
            payload['attributes'] = translate_in_attributes_section payload['attributes']
          end

          if payload.include? 'journal'
            payload['journal'].each_index do |idx|
              payload['journal'][idx] = translate_in_attributes_section payload['attributes']
            end
          end

        end

        def translate_in_attributes_section section

          ['use', 'require'].each do |type|
            if section.include? type
              new_section_type = {}
              section[type].each do |key, value|
                attr = attribute_for_uuid type, key
                new_section_type[attr ? attr.name : key] = value
              end
              section[type] = new_section_type
            end
          end

          section

        end

      end
    end
  end
end