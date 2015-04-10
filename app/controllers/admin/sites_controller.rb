require 'json'

module Admin
  class SitesController < ApplicationController

    before_action :require_session_admin!

    def index

      redirect_to edit_admin_site_url(@site)

    end

    def show

      redirect_to edit_admin_site_url(@site)

    end

    def edit

    end

    def update

      @site.update params[:site].permit [
                                            :title,
                                            :heading,
                                            :css,
                                            :mobile_appicon
                                        ]

      redirect_to root_url

    end

  end
end