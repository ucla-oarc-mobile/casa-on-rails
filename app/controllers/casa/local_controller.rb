module Casa
  class LocalController < ApplicationController

    def all

      if params[:query]
        apps = App.where_query_string params[:query]
      else
        apps = App.where enabled: true
      end

      render json: apps.map(&:to_local_payload)

    end

    def query

      apps = App.where_query JSON.parse request.body.read

      unless apps.nil? or !app.enabled
        render json: apps.map(&:to_local_payload)
      else
        render status: 501, plain: 'Not implemented'
      end

    end

    def one

      app = App.where_identity(id: params[:id], originator_id: params[:originator_id])

      unless app.nil? or !app.enabled
        render json: app.to_local_payload
      else
        render status: 404, plain: 'Not found'
      end

    end

  end
end
