module Admin
  class InPayloadsController < ApplicationController

    before_action :require_session_admin!

    def index

      @in_payloads = InPayload.where(app_id: nil, deleted_at: nil)

    end

    def show

      @in_payload = InPayload.find params[:id]

    end

    def to_app

      @in_payload = InPayload.find params[:in_payload_id]

      attributes = @in_payload.content_data['attributes']
      attributes = attributes.merge(attributes['use']).merge(attributes['require'])

      if @in_payload.related_app
        @app = @in_payload.related_app
      else
        @app = App.new
      end

      @app.title = attributes['title'] if attributes.has_key?('title')
      @app.uri = attributes['uri']
      @app.icon = attributes['icon'] if attributes.has_key?('icon')
      @app.description = attributes['description'] if attributes.has_key?('description')
      @app.enabled = true
      @app.share = attributes['share']
      @app.propagate = attributes['propagate']
      @app.updated_at = attributes['timestamp']
      @app.casa_id = @in_payload.casa_id
      @app.casa_originator_id = @in_payload.casa_originator_id
      @app.app_tags = attributes['tags'].map(){ |t| AppTag.new(name: t) }
      @app.short_description = attributes['short_description'] if attributes.has_key?('short_description')
      @app.privacy_url = attributes['privacy_url'] if attributes.has_key?('privacy_url')
      @app.accessibility_url = attributes['accessibility_url'] if attributes.has_key?('accessibility_url')
      @app.vpat_url = attributes['vpat_url'] if attributes.has_key?('vpat_url')
      @app.acceptable = attributes['acceptable'].to_json if attributes.has_key?('acceptable')

      if attributes.include? 'lti'
        @app.lti = true
        @app.lti_launch_url = attributes['lti']['launch_url'] if attributes['lti'].has_key?('launch_url')
        @app.lti_configuration_url = attributes['lti']['configuration_url'] if attributes['lti'].has_key?('configuration_url')
        @app.lti_registration_url = attributes['lti']['registration_url'] if attributes['lti'].has_key?('registration_url')
        @app.lti_outcomes = attributes['lti']['outcomes'] if attributes['lti'].has_key?('outcomes')
        if attributes['lti'].include? 'versions_supported'
          attributes['lti']['versions_supported'].each do |version|
            @app.app_lti_versions << AppLtiVersion.new(version: version)
          end
        end
      end

      if attributes.include? 'ios_app'
        @app.ios_app_id = attributes['ios_app']['id'] if attributes['ios_app'].has_key?('id')
        @app.ios_app_scheme = attributes['ios_app']['scheme'] if attributes['ios_app'].has_key?('scheme')
        @app.ios_app_path = attributes['ios_app']['path'] if attributes['ios_app'].has_key?('path')
        @app.ios_app_affiliate_data = attributes['ios_app']['affiliate_data'] if attributes['ios_app'].has_key?('affiliate_data')
      end

      if attributes.include? 'android_app'
        @app.android_app_package = attributes['android_app']['package'] if attributes['android_app'].has_key?('package')
        @app.android_app_scheme = attributes['android_app']['scheme'] if attributes['android_app'].has_key?('scheme')
        @app.android_app_action = attributes['android_app']['action'] if attributes['android_app'].has_key?('action')
        @app.android_app_category = attributes['android_app']['category'] if attributes['android_app'].has_key?('category')
        @app.android_app_component = attributes['android_app']['component'] if attributes['android_app'].has_key?('component')
      end

      if attributes.include? 'author'
        authors = attributes['author'].is_a?(Array) ? attributes['author'] : [attributes['author']]
        authors.each { |author| @app.app_authors << AppAuthor.new(author) }
      end

      if attributes.include? 'organization'
        organizations = attributes['organization'].is_a?(Array) ? attributes['organization'] : [attributes['organization']]
        organizations.each { |organization| @app.app_organizations << AppOrganization.new(organization) }
      end

      if attributes.include? 'privacy'
        privacy = {}
        attributes['privacy'].each do |classification, types|
          types.each do |type, level|
            if level == true
              level = 'true'
            elsif level == false
              level = 'false'
            else
              level = "\"#{level}\""
            end
            privacy["#{classification}_#{type}"] = level
          end
        end
        @app.app_privacy_policy = AppPrivacyPolicy.new(privacy)
      end

      if attributes.include? 'browser_features'
        attributes['browser_features'].each do |feature, level|
          unless level == 'none'
            @app.app_browser_features << AppBrowserFeature.new(feature: feature, level: level)
          end
        end
      end

      @app.save
      @in_payload.update(app_id: @app.id)

      redirect_to @app

    end

    def destroy

      @in_payload = InPayload.find params[:id]
      @in_payload.update(deleted_at: Time.now)

      if params[:ignore]
        InPayloadIgnore.create casa_id: @in_payload.casa_id,
                               casa_originator_id: @in_payload.casa_originator_id
      end

      redirect_to admin_in_payloads_path

    end

  end
end