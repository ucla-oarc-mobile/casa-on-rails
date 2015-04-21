module Apps
  class RatingsController < ApplicationController

    before_action :require_session_user!

    before_action do
      @app = App.find params[:id]
    end

    def create

      identifier = {}
      identifier[:user_id] = session_user.id
      identifier[:app_id] = @app.id

      data = identifier.merge params[:app_rating].permit 'score', 'review'
      data[:review] = nil if data['review'].strip.length == 0

      AppRating.where(identifier).each { |rating| rating.delete }
      AppRating.create(data)

      redirect_to @app

    end

    def destroy

      @rating = AppRating.find params[:rating_id]
      @rating.destroy if session_user and (session_user.admin == 1 or @rating.user_id = session_user.id)
      redirect_to app_url params[:id]

    end

  end
end