module Casa
  class OutController < ApplicationController

    before_action do

      secret = params[:secret]
      request_address = IPAddr.new(request.ip) # request.env['REMOTE_ADDR']

      out_peers = OutPeer.where(secret: nil) + OutPeer.where(secret: '')
      out_peers = out_peers + OutPeer.where(secret: secret) if secret

      @matching_peer_ids = []
      out_peers.each do |out_peer|
        netmask = (out_peer.netmask and out_peer.netmask != '') ? out_peer.netmask : '255.255.255.255'
        if request_address.mask(netmask) == IPAddr.new(out_peer.address).mask(netmask)
          @matching_peer_ids << out_peer.id
        end
      end

    end

    def all

      public_apps = App.where(enabled: true, share: true, restrict: false)
      private_apps = App.includes(:app_out_peer_permissions).where(enabled: true, share: true, restrict: true, app_out_peer_permissions: { out_peer_id: @matching_peer_ids })
      apps = public_apps + private_apps

      apps.each do |app|
        event.shared app,
                     peer_id: params[:requestor_id],
                     peer_name: params[:requestor_name],
                     peer_description: request.ip
      end

      render json: apps.map(&:to_transit_payload)

    end

    def one

      app = App.where_identity(id: params[:id], originator_id: params[:originator_id])

      unless app.nil? or !app.enabled
        unless app.restrict and (app.app_out_peer_permissions.map(){ |p| p.out_peer_id } & @matching_peer_ids).length == 0
          event.shared app,
                       peer_id: params[:requestor_id],
                       peer_name: params[:requestor_name],
                       peer_description: request.ip
          render json: app.to_transit_payload
        else
          render status: 403, plain: 'Forbidden'
        end
      else
        render status: 404, plain: 'Not found'
      end

    end

  end
end
