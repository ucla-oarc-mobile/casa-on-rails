module Casa
  class Payload
    module ClassMethods
      module FilterIn

        def filter_in payload, peer

          passing = true

          if InPayloadIgnore.where(casa_id: payload['identity']['id'],
                                   casa_originator_id: payload['identity']['originator_id']).count > 0
            passing = false
          end

          # filter out any payload with a `require` attribute we don't support
          if payload['attributes'].has_key?('require')
            payload['attributes']['require'].each_key do |key|
              unless Casa::Payload.attributes_map['require'].include?(key)
                passing = false
                return false
              end
            end
          end

          (peer.in_filter_rulesets | InFilterRuleset.global).each do |ruleset|

            rules = ruleset.rules_object
            merged_attributes = payload['attributes']
            merged_attributes.merge(payload['attributes']['use']) if(payload['attributes'].has_key?('use'))
            merged_attributes.merge(payload['attributes']['require']) if(payload['attributes'].has_key?('require'))

            if rules.has_key? '_global'
              if rules['_global'].has_key? 'require'
                rules['_global']['require'].each do |requirements|
                  found = false
                  requirements = [requirements] unless requirements.is_a? Array
                  requirements.each do |requirement|
                    found = true if merged_attributes.has_key? requirement
                  end
                  passing = false unless found
                end
              end
            end

            # TODO: move this to the lti attribute handler

            if rules.has_key? 'lti'
              if rules['lti'].has_key? 'versions'
                if merged_attributes.has_key? 'lti'
                  if merged_attributes['lti'].has_key? 'versions_supported'
                    found = false
                    rules['lti']['versions'].each do |version|
                      found = true if merged_attributes['lti']['versions_supported'].include? version
                    end
                    passing = false unless found
                  else
                    passing = false
                  end
                else
                  passing = false
                end
              end
            end

            # TODO: move this to the categories attribute handler

            if rules.has_key? 'categories'
              if rules['categories'].has_key? 'require'
                if merged_attributes.has_key? 'categories'
                  found = false
                  rules['categories']['require'].each do |category|
                    found = true if merged_attributes['categories'].include? category
                  end
                  passing = false unless found
                else
                  passing = false
                end
              end
              if rules['categories'].has_key? 'require_not'
                if merged_attributes.has_key? 'categories'
                  found = false
                  rules['categories']['require_not'].each do |category|
                    found = true if merged_attributes['categories'].include? category
                  end
                  passing = false if found
                end
              end
            end

          end

          passing

        end

      end
    end
  end
end