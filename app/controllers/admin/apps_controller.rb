require 'json'

module Admin
  class AppsController < ApplicationController

    before_action :require_session_admin!

    def index

      @apps = App.all

    end

    def new

      @app = App.new
      @categories = Category.order name: :asc
      @out_peers = OutPeer.order name: :asc

    end

    def create

      @app = App.new app_params
      @app.category_ids = params[:app][:categories]

      params[:app_lti_versions].each { |version| @app.app_lti_versions << AppLtiVersion.new(version: version) } if params[:app_lti_versions]
      JSON.parse(params[:app_authors]).each { |app_author_params| @app.app_authors << AppAuthor.new(app_author_params) }
      JSON.parse(params[:app_organizations]).each { |app_organization_params| @app.app_organizations << AppOrganization.new(app_organization_params) }

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

      if params[:app][:restrict_launch]
        new_methods = params[:app][:app_launch_methods].keep_if(){ |m| m != '' }
        new_methods.each do |m|
          @app.app_launch_methods << AppLaunchMethod.new(method: m)
        end
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

    end

    def update

      @app = App.find params[:id]
      @app.category_ids = params[:app][:categories]

      if params[:app_lti_versions]
        vs = {}
        @app.app_lti_versions.each { |r| vs[r.version] = r }
        params[:app_lti_versions].each { |version| @app.app_lti_versions << AppLtiVersion.new(version: version) unless vs.has_key?(version) }
        @app.app_lti_versions.each { |r| r.delete unless params[:app_lti_versions].include?(r.version) }
      else
        @app.app_lti_versions.each { |r| r.delete }
      end

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
        JSON.parse(params[:app_authors]).each do |app_author_params|
          @app.app_authors << AppAuthor.new(app_author_params)
        end
      end

      if params[:app_organizations]
        @app.app_organizations.each { |o| o.delete }
        JSON.parse(params[:app_organizations]).each do |app_organization_params|
          @app.app_organizations << AppOrganization.new(app_organization_params)
        end
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
        :restrict,
        :mobile_support,
        :restrict_launch,
        :official,
        :primary_contact_name,
        :primary_contact_email,
        :caliper,
        :caliper_metric_profiles,
        :caliper_ims_global_certifications
      ])

    end

  end
end