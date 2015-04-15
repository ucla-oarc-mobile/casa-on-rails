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

      AppRating.where(identifier).each { |rating| rating.delete }
      AppRating.create(identifier.merge params[:app_rating].permit :score, :review)

      redirect_to @app

    end

  end
end