module Admin
  class InPeersController < ApplicationController

    before_action :require_session_admin!

    def index

      @in_peers = InPeer.all

    end

    def new

      @in_peer = InPeer.new

    end

    def create

      @in_peer = InPeer.new in_peer_params

      if @in_peer.save
        redirect_to [:admin, @in_peer]
      else
        render 'new'
      end

    end

    def show

      @in_peer = InPeer.find params[:id]

    end

    def edit

      @in_peer = InPeer.find params[:id]

    end

    def update

      @in_peer = InPeer.find params[:id]

      if @in_peer.update in_peer_params
        redirect_to [:admin, @in_peer]
      else
        render 'edit'
      end

    end

    def destroy

      @in_peer = InPeer.find params[:id]
      @in_peer.destroy

      redirect_to admin_in_peers_path

    end

  private

    def in_peer_params

      params.require(:in_peer).permit([
        :name,
        :uri,
        :secret,
        :casa_id
      ])

    end

  end
end