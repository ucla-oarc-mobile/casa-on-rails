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

      JSON.parse(params[:app_authors]).each { |app_author_params| @app.app_authors << AppAuthor.new(app_author_params) }
      JSON.parse(params[:app_organizations]).each { |app_organization_params| @app.app_organizations << AppOrganization.new(app_organization_params) }

      if params[:app][:lti] == '1'
        JSON.parse(params[:app_lti_configs]).each{|app_lti_config |  @app.app_lti_configs << AppLtiConfig.new(app_lti_config) }
      end

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

      new_features = params[:app][:app_features].gsub("\r", '').split("\n")
      new_features.each do |t|
        @app.app_features << AppFeature.new(feature_name: t)
      end

      [:wcag_text_alternatives, :wcag_time_based_media,:wcag_adaptable, :wcag_distinguishable,
       :wcag_keyboard_accessible, :wcag_enough_time, :wcag_seizures, :wcag_navigable, :wcag_readable,
       :wcag_predictable, :wcag_input_assistance, :wcag_compatible].each do |wcag_concept|

        params[wcag_concept].each do |guideline|
          @app.app_wcag_guidelines << AppWcagGuideline.new(guideline: guideline)
        end if params[wcag_concept]

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
        :accessibility_url,
        :vpat_url,
        :privacy_url,
        :lti,
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
        :supported_languages,
        :license_is_free,
        :license_is_paid,
        :license_is_recharge,
        :license_is_by_seat,
        :license_is_free,
        :license_is_subscription,
        :license_is_ad_supported,
        :license_is_other,
        :license_text,
        :security_uses_https,
        :security_uses_additional_encryption,
        :security_requires_cookies,
        :security_requires_third_party_cookies,
        :security_session_lifetime,
        :security_cloud_vendor,
        :security_policy_url,
        :security_sla_url,
        :security_text,
        :student_data_stores_local_data,
        :student_data_requires_account,
        :student_data_has_opt_out_for_data_collection,
        :student_data_has_opt_in_for_data_collection,
        :student_data_shows_eula,
        :student_data_is_app_externally_hosted,
        :student_data_stores_pii,
        :wcag_url
      ])

    end

  end
end