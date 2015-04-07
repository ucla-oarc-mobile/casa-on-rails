module Admin
  class LtiConsumersController < ApplicationController

    before_action :require_session_admin!

    def index

      @lti_consumers = LtiConsumer.all

    end

    def new

      @lti_consumer = LtiConsumer.new

    end

    def create

      @lti_consumer = LtiConsumer.new lti_consumer_params

      if @lti_consumer.save
        redirect_to [:admin, @lti_consumer]
      else
        render 'new'
      end

    end

    def show

      @lti_consumer = LtiConsumer.find params[:id]

    end

    def edit

      @lti_consumer = LtiConsumer.find params[:id]

    end

    def update

      @lti_consumer = LtiConsumer.find params[:id]

      if @lti_consumer.update lti_consumer_params
        redirect_to [:admin, @lti_consumer]
      else
        render 'edit'
      end

    end

    def destroy

      @lti_consumer = LtiConsumer.find params[:id]
      @lti_consumer.destroy

      redirect_to admin_lti_consumers_path

    end

    private

    def lti_consumer_params

      params.require(:lti_consumer).permit([
                                          :name,
                                          :key,
                                          :secret
                                      ])

    end

  end
end