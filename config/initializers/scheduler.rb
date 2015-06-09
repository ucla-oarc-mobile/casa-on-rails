require 'time'
require 'json'
require 'rufus-scheduler'

Rufus::Scheduler.singleton.every '30m' do

  InPeer.all.each do |peer|

    Rails.logger.info "#{Time.now} - #{peer.name} - Query for apps"

    begin

      payloads = peer.get_payloads

      payloads.each do |payload|

        original_payload = payload.to_json

        # do not accept another client's interpretation of attributes
        payload.delete 'attributes' if payload.include? 'attributes'

        # must translate recognized attributes from machine-readable
        # UUIDs to human-readable names
        Casa::Payload.translate_in payload

        # TODO: add filter to drop payloads with unrecognized `require` attributes

        # must create an attributes section by squashing the journal and
        # the original section
        Casa::Payload.squash_in payload

        # skip if receiving a payload introduced by this engine
        if Rails.application.config.casa[:engine][:uuid] == payload['identity']['originator_id']
          Rails.logger.info "#{Time.now} - #{peer.name} - SKIP - #{payload['identity']['id']}@#{payload['identity']['originator_id']}"
          next
        end

        # must skip this iteration and go to next unless filter passes
        unless Casa::Payload.filter_in payload, peer
          Rails.logger.info "#{Time.now} - #{peer.name} - SKIP - #{payload['identity']['id']}@#{payload['identity']['originator_id']}"
          next
        end

        # if this is the newest payload seen for the app, then add it to the queue
        if InPayload.where({
                             casa_originator_id: payload['identity']['originator_id'],
                             casa_id: payload['identity']['id']
                           }).where("casa_timestamp >= ?", payload['attributes']['timestamp']).count == 0

          begin

            payload = InPayload.create casa_originator_id: payload['identity']['originator_id'],
                                       casa_id: payload['identity']['id'],
                                       casa_timestamp: payload['attributes']['timestamp'],
                                       in_peer_id: peer.id,
                                       content: payload.to_json,
                                       original_content: original_payload

            # mark older versions of this payload as deleted so only one copy of the payload is shown at any time
            # in the queued apps list
            InPayload.where(casa_originator_id: payload['identity']['originator_id'],
                            casa_id: payload['identity']['id'],
                            deleted_at: nil).where("created_at < ?", payload['attributes']['timestamp']).each do |old_in_payload|
              old_in_payload.update(deleted_at: Time.now)
            end

            Rails.logger.info "#{Time.now} - #{peer.name} - ADDED - #{payload.casa_id}@#{payload.casa_originator_id}"

          rescue
          end

        end

      end

    rescue => e

      Rails.logger.error "#{Time.now} - #{peer.name} - Query for apps failed: #{e}"

    end


  end

end
