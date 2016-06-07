require 'json'

module Admin
  class AppsController < ApplicationController

    before_action :require_session_admin!, only: [:new, :create]
    before_action :require_edit_privilege!, only: [:edit, :update]

    def index

      @apps = App.all

    end

    def new

      @app = App.new
      @categories = Category.order name: :asc
      @out_peers = OutPeer.order name: :asc
      @lti_consumers = LtiConsumer.order name: :asc

    end

    def create

      @app = App.new app_params
      @app.category_ids = params[:app][:categories]

      JSON.parse(params[:app_authors]).each { |app_author_params| @app.app_authors << AppAuthor.new(app_author_params) }
      JSON.parse(params[:app_organizations]).each { |app_organization_params| @app.app_organizations << AppOrganization.new(app_organization_params) }
      JSON.parse(params[:app_lti_configs]).each{|app_lti_config | @app.app_lti_configs << AppLtiConfig.new(app_lti_config) }

      if params[:app][:default_app_order]
        @app.default_app_order = params[:app][:default_app_order]
      else
        @app.default_app_order = nil
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

      if params[:app][:app_out_peer_permissions]
        new_out_peer_ids = params[:app][:app_out_peer_permissions].map(&:to_i).keep_if(){ |i| i > 0 }
        new_out_peer_ids.each do |id|
          @app.app_out_peer_permissions << AppOutPeerPermission.new(out_peer_id: id)
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

      if params[:app][:restrict_launch]
        new_methods = params[:app][:app_launch_methods].keep_if(){ |m| m != '' }
        new_methods.each do |m|
          @app.app_launch_methods << AppLaunchMethod.new(method: m)
        end
      end

      [:wcag_text_alternatives, :wcag_time_based_media,:wcag_adaptable, :wcag_distinguishable,
       :wcag_keyboard_accessible, :wcag_enough_time, :wcag_seizures, :wcag_navigable, :wcag_readable,
       :wcag_predictable, :wcag_input_assistance, :wcag_compatible].each do |wcag_concept|

        params[wcag_concept].each do |guideline|
          @app.app_wcag_guidelines << AppWcagGuideline.new(guideline: guideline)
        end if params[wcag_concept]

      end

      if @app.save
        redirect_to @app
      else
        render 'new'
      end

    end

    def edit

      @app = App.find params[:id]
      @categories = Category.order name: :asc
      @out_peers = OutPeer.order name: :asc
      @lti_consumers = LtiConsumer.order name: :asc

    end

    def update

      @categories = Category.order name: :asc
      @lti_consumers = LtiConsumer.order name: :asc

      @app = App.find params[:id]
      @app.category_ids = params[:app][:categories]

      if params[:app_browser_features]
        fs = {}
        @app.app_browser_features.each { |r| fs[r.feature] = r }
        params[:app_browser_features].each do |feature, level|
          if level == 'none'
            if fs.has_key?(feature)
              fs[feature].delete
            end
          else
            if fs.has_key?(feature)
              fs[feature].update(level: level)
            else
              @app.app_browser_features << AppBrowserFeature.new(feature: feature, level: level)
            end
          end
        end
      end

      if params[:app][:default_app_order]
        @app.default_app_order = params[:app][:default_app_order]
      else
        @app.default_app_order = nil
      end

      if @app.app_privacy_policy
        if params[:privacy][:enable] == '1'
          @app.app_privacy_policy.update params[:app_privacy_policy].permit!
        else
          @app.app_privacy_policy.delete
        end
      else
        if params[:privacy][:enable] == '1'
          @app.app_privacy_policy = AppPrivacyPolicy.new params[:app_privacy_policy].permit!
        else
          @app.app_privacy_policy = nil
        end
      end

      if params[:app_authors]
        @app.app_authors.each { |a| a.delete }
        @app.app_authors.clear

        JSON.parse(params[:app_authors]).each do |app_author_params|
          @app.app_authors << AppAuthor.new(app_author_params)
        end
      end

      if params[:app_organizations]
        @app.app_organizations.each { |o| o.delete }
        @app.app_organizations.clear

        JSON.parse(params[:app_organizations]).each do |app_organization_params|
          @app.app_organizations << AppOrganization.new(app_organization_params)
        end
      end

      if params[:app][:lti] == '1'
        if params[:app_lti_configs]
          @app.app_lti_configs.each { |c| c.delete }
          # Delete the configs from the app instance itself. Instead of doing this, true updates / upserts should
          # be performed so the Ruby object state can match the database state without resorting to this clear() hack.
          @app.app_lti_configs.clear

          JSON.parse(params[:app_lti_configs]).each do |app_lti_config|
            @app.app_lti_configs << AppLtiConfig.new(app_lti_config)
          end

          # This makes the user's experience better if they forget to check the "default" checkbox and they are
          # setting up only one LTI config. It means the app does not have to nag them for something silly.
          if @app.app_lti_configs.size == 1
            @app.app_lti_configs[0].lti_default = true
          end
        end
      else
        params[:app_lti_configs] = nil
        @app.lti = '0'
        @app.app_lti_configs.each { |c| c.delete }
        @app.app_lti_configs.clear
      end

      if params[:app][:app_out_peer_permissions]
        new_out_peer_ids = params[:app][:app_out_peer_permissions].map(&:to_i).keep_if(){ |i| i > 0 }
        current_out_peer_ids = @app.app_out_peer_permissions.map() { |p| p.out_peer.id }
        (new_out_peer_ids - current_out_peer_ids).each do |id|
          @app.app_out_peer_permissions << AppOutPeerPermission.new(out_peer_id: id)
        end
        (current_out_peer_ids - new_out_peer_ids).each do |id|
          AppOutPeerPermission.where(app_id: @app.id, out_peer_id: id).each { |r| r.delete }
        end
      else
        @app.app_out_peer_permissions.each { |p| p.delete }
      end

      current_tags = @app.app_tags.map(){ |t| t.name }
      new_tags = params[:app][:app_tags].gsub("\r", '').split("\n")
      (current_tags - new_tags).each do |t|
        @app.app_tags.where(name: t).each { |r| r.delete }
      end
      (new_tags - current_tags).each do |t|
        @app.app_tags << AppTag.new(name: t)
      end

      current_competencies = @app.app_competencies.map(){ |t| t.name }
      new_competencies = params[:app][:app_competencies].gsub("\r", '').split("\n")
      (current_competencies - new_competencies).each do |t|
        @app.app_competencies.where(name: t).each { |r| r.delete }
      end
      (new_competencies - current_competencies).each do |t|
        @app.app_competencies << AppCompetency.new(name: t)
      end

      current_features = @app.app_features.map(){ |t| t.feature_name }
      new_features = params[:app][:app_features].gsub("\r", '').split("\n")
      (current_features - new_features).each do |t|
        @app.app_features.where(feature_name: t).each { |r| r.delete }
      end
      (new_features - current_features).each do |t|
        @app.app_features << AppFeature.new(feature_name: t)
      end

      current_wcag_guidelines = @app.app_wcag_guidelines.map(){ |t| t.guideline }

      new_wcag_guidelines = []

      [:wcag_text_alternatives, :wcag_time_based_media,:wcag_adaptable, :wcag_distinguishable,
       :wcag_keyboard_accessible, :wcag_enough_time, :wcag_seizures, :wcag_navigable, :wcag_readable,
       :wcag_predictable, :wcag_input_assistance, :wcag_compatible].each do |wcag_concept|

        params[wcag_concept].each do |guideline|
          new_wcag_guidelines <<  guideline
        end if params[wcag_concept]

      end

      (current_wcag_guidelines - new_wcag_guidelines).each do |g|
        @app.app_wcag_guidelines.where(guideline: g).each { |g| g.delete }
      end

      (new_wcag_guidelines - current_wcag_guidelines).each do |g|
        Rails.logger.info 'G: ' + g.to_s
        @app.app_wcag_guidelines << AppWcagGuideline.new(guideline: g)
      end

      if params[:app][:restrict_launch]
        current_methods = @app.app_launch_methods.map(){ |t| t.method }
        new_methods = params[:app][:app_launch_methods].keep_if(){ |m| m != '' }
        (current_methods - new_methods).each do |m|
          @app.app_launch_methods.where(method: m).each { |m| m.delete }
        end
        (new_methods - current_methods).each do |m|
          @app.app_launch_methods << AppLaunchMethod.new(method: m)
        end
      else
        @app.app_launch_methods.each { |m| m.delete }
      end

      if @app.update app_params
        redirect_to @app
      else
        render 'edit'
      end

    end

    def destroy

      @app = App.find params[:id]
      @app.destroy

      redirect_to admin_apps_path

    end

    def require_edit_privilege!
      if session_user
        created_by_id = App.find(params[:id]).created_by
        redirect_to root_path unless session_user.admin || created_by_id == session_user.id
      else
        redirect_to session_path
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
        :lti,
        :accessibility_url,
        :vpat_url,
        :privacy_url,
        :restrict,
        :mobile_support,
        :restrict_launch,
        :official,
        :primary_contact_name,
        :primary_contact_email,
        :support_contact_name,
        :support_contact_email,
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
        :wcag_url,
        :overall_review_status,
        :privacy_review_status,
        :security_review_status,
        :accessibility_review_status,
        :tool_review_url,
      ])

    end

  end
end