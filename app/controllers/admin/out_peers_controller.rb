module Admin
  class OutPeersController < ApplicationController

    before_action :require_session_admin!

    def index

      @out_peers = OutPeer.all

    end

    def new

      @out_peer = OutPeer.new

    end

    def create

      @out_peer = OutPeer.new out_peer_params

      if @out_peer.save
        redirect_to [:admin, @out_peer]
      else
        render 'new'
      end

    end

    def show

      @out_peer = OutPeer.find params[:id]

    end

    def edit

      @out_peer = OutPeer.find params[:id]

    end

    def update

      @out_peer = OutPeer.find params[:id]

      if @out_peer.update out_peer_params
        redirect_to [:admin, @out_peer]
      else
        render 'edit'
      end

    end

    def destroy

      @out_peer = OutPeer.find params[:id]
      @out_peer.destroy

      redirect_to admin_out_peers_path

    end

  private

    def out_peer_params

      params.require(:out_peer).permit([
        :name,
        :address,
        :netmask,
        :secret
      ])

    end

  end
end