require 'json'

module Manage
  class AppsController < ApplicationController

    before_action :require_session_user!, except: [:new]

    def index

      @apps = session_user.apps.order(created_at: :desc)

    end

    def new

      if session_user
        @app = App.new
        @categories = Category.all
      else
        @contact = Rails.application.config.store[:user_contact]
        render 'guest'
      end

    end

    def create

      data = app_params
      data[:enabled] = false
      data[:share] = false
      data[:propagate] = false
      @app = App.new data
      @app.category_ids = params[:app][:categories]

      params[:app_lti_versions].each { |version| @app.app_lti_versions << AppLtiVersion.new(version: version) } if params[:app_lti_versions]
      JSON.parse(params[:app_authors]).each { |app_author_params| @app.app_authors << AppAuthor.new(app_author_params) }
      JSON.parse(params[:app_organizations]).each { |app_organization_params| @app.app_organizations << AppOrganization.new(app_organization_params) }

      if params[:privacy][:enable] == '1'
        @app.app_privacy_policy = AppPrivacyPolicy.new(params[:app_privacy_policy].permit!) if params[:app_privacy_policy]
      end

      if params[:app_browser_features]
        params[:app_browser_features].each do |feature, level|
          unless level == 'none'
            @app.app_browser_features << AppBrowserFeature.new(feature: feature, level: level)
          end
        end
      end

      new_tags = params[:app][:app_tags].gsub("\r", '').split("\n")
      new_tags.each do |t|
        @app.app_tags << AppTag.new(name: t)
      end

      new_competencies = params[:app][:app_competencies].gsub("\r", '').split("\n")
      new_competencies.each do |t|
        @app.app_competencies << AppCompetency.new(name: t)
      end

      @app.created_by = session_user.id

      if @app.save
        render 'created'
      else
        render 'new'
      end

    end

  private

    def app_params

      params.require(:app).permit([
        :title,
        :uri,
        :description,
        :short_description,
        :enabled,
        :share,
        :propagate,
        :icon,
        :ios_app_id,
        :ios_app_scheme,
        :ios_app_path,
        :ios_app_affiliate_data,
        :android_app_package,
        :android_app_scheme,
        :android_app_action,
        :android_app_category,
        :android_app_component,
        :lti_configuration_url,
        :lti_registration_url,
        :lti_outcomes,
        :accessibility_url,
        :vpat_url,
        :privacy_url,
        :lti,
        :lti_launch_url,
        :mobile_support,
        :primary_contact_name,
        :primary_contact_email,
        :support_contact_name,
        :support_contact_email,
        :sharing_preference,
        :caliper,
        :caliper_metric_profiles,
        :caliper_ims_global_certifications,
        :download_size,
        :supported_languages
      ])

    end

  end
end