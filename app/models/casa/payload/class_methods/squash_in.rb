module Casa
  class Payload
    module ClassMethods
      module SquashIn

        def squash_in payload

          # copy basic properties directly from original payload
          payload['attributes'] = {
              'uri' => payload['original']['uri'],
              'share' => payload['original']['share'],
              'propagate' => payload['original']['propagate'],
              'timestamp' => payload['original']['timestamp']
          }

          # mark share as false if app isn't to be propagated to prevent sharing it further
          payload['attributes']['share'] = false unless payload['original']['propagate']

          # copy all properties from original into attributes
          ['use','require'].each do |type|
            payload['attributes'][type] = {}
            payload['original'][type].each do |key, value|
              if attributes_map[type].include?(key)
                attr = attributes_map[type][key]
                payload['attributes'][type][attr.name] = value
              end
            end
          end

          # for each journal entry, update properties from original into attributes
          # TODO: support attributes when they specify custom journaling methods (right now only direct copy supported)
          if payload.include? 'journal'
            payload['journal'].each do |entry|
              ['use', 'require'].each do |type|
                entry[type].each do |key, value|
                  if attributes_map.include? key
                    attr = attributes_map[type][key]
                    payload['attributes'][type][attr.name] = value
                  end
                end
              end
            end
          end

        end

      end
    end
  end
end