module Admin
  class InFilterRulesetsController < ApplicationController

    before_action :require_session_admin!

    def index

      @in_filter_rulesets = InFilterRuleset.all

    end

    def new

      @in_filter_ruleset = InFilterRuleset.new

    end

    def create

      InFilterRuleset.create params[:in_filter_ruleset].permit([:in_peer_id, :rules])
      redirect_to admin_in_filter_rulesets_url

    end

    def edit

      @in_filter_ruleset = InFilterRuleset.find params[:id]

    end

    def update

      @in_filter_ruleset = InFilterRuleset.find params[:id]
      @in_filter_ruleset.update params[:in_filter_ruleset].permit([:in_peer_id, :rules])
      redirect_to admin_in_filter_rulesets_url

    end

    def destroy

      @in_filter_ruleset = InFilterRuleset.find params[:id]
      @in_filter_ruleset.destroy
      redirect_to admin_in_filter_rulesets_path

    end

  end
end