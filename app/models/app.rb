require 'validators/uri_validator'

class App < ActiveRecord::Base
  include AttributeConcern,
          ActiveModel::Validations,
          ActionView::Helpers::SanitizeHelper,
          ActionView::Helpers::TextHelper

  NULL_IF_BLANK_ATTRS = %w(icon description short_description privacy_url accessibility_url vpat_url wcag_url acceptable
                           ios_app_id ios_app_scheme ios_app_path ios_app_affiliate_data android_app_package android_app_scheme
                           android_app_action android_app_category android_app_component download_size supported_languages
                           security_session_lifetime security_cloud_vendor security_policy_url security_sla_url security_text
                           license_text support_contact_name support_contact_email primary_contact_name primary_contact_email
                           overall_review_status privacy_review_status security_review_status accessibility_review_status
                           tool_review_url privacy_text)

  RECOMMENDED_FOR_USE = 100
  USE_WITH_CAUTION = 101
  NOT_RECOMMENDED = 102
  IN_PROGRESS = 103

  class LTIExistenceValidator < ActiveModel::Validator
    def validate(record)
      if record.lti && record.app_lti_configs.empty?
        record.errors.add(:lti, 'At least one LTI Configuration is required if "Supports LTI" is checked.')
      end
    end
  end

  class LTIDefaultValidator < ActiveModel::Validator
    def validate(record)
      number_of_default_configs = 0

      record.app_lti_configs.each {
          |c|  number_of_default_configs += 1 if c.lti_default
      } unless record.app_lti_configs.empty?

      if number_of_default_configs > 1
        record.errors.add(:lti, 'Only one LTI configuration can be set as the default.')
      end
      if record.app_lti_configs.size > 1 && number_of_default_configs == 0
        record.errors.add(:lti, 'When multiple LTI configurations are being created, one of them must be set as the default.')
      end
    end
  end

  class PrivacyPolicyValidator < ActiveModel::Validator
    def validate(record)
      # An app must have either a privacy policy text or URL, but not both
      if record.privacy_url.blank? && record.privacy_text.blank?
        record.errors.add(:privacy_policy, "A privacy policy is required (either the text or a URL).")
      elsif !record.privacy_url.blank? && !record.privacy_text.blank?
        record.errors.add(:privacy_policy, "You cannot use both a privacy policy text and an external URL.")
      end
    end
  end

  # Guard against the case where new enum values are added without being referenced here or
  # if the API is being used headlessly.
  class ReviewEnumValidator < ActiveModel::Validator
    def validate(record)
      [[:overall_review_status, record.overall_review_status ],
       [:privacy_review_status, record.privacy_review_status],
       [:security_review_status, record.security_review_status],
       [:accessibility_review_status, record.accessibility_review_status]].each { |key, value|
          unless value.blank? || record.is_valid_review_status?(value)
            record.errors.add(key, 'The selected status is invalid.')
          end
      }
    end
  end

  has_and_belongs_to_many :categories
  has_many :app_tags, :dependent => :destroy
  has_many :app_competencies, :dependent => :destroy
  has_many :app_features, :dependent => :destroy
  has_many :app_authors, :dependent => :destroy
  has_many :app_organizations, :dependent => :destroy
  belongs_to :app_privacy_policy, :dependent => :destroy
  has_many :app_media_requirements, :dependent => :destroy
  has_many :app_lti_configs, :dependent => :destroy
  has_many :app_browser_features, :dependent => :destroy
  has_many :app_out_peer_permissions, :dependent => :destroy
  has_many :app_launch_methods, :dependent => :destroy
  has_many :app_ratings, :dependent => :destroy
  has_many :app_wcag_guidelines, :dependent => :destroy

  scope :available_to_launch_method, lambda { |m|
    if m
      joins('LEFT OUTER JOIN `app_launch_methods` ON `apps`.`id` = `app_launch_methods`.`app_id`')
          .where('restrict_launch = 0 OR `app_launch_methods`.`method` = :method', { method: m })
    end
  }

  validates_with LTIExistenceValidator
  validates_with LTIDefaultValidator
  validates_with ReviewEnumValidator
  validates_with PrivacyPolicyValidator

  validate :caliper_attribute_is_valid

  validates :title,
    presence: true,
    length: { maximum: 255 }

  validates :description,
    presence: true

  validates :uri,
    uri: true

  validates :primary_contact_name,
    length: { maximum: 255}

  validates :primary_contact_email,
    presence: true,
    length: { minimum: 6, maximum: 255}

  validates :support_contact_email,
    length: { minimum: 6, maximum: 255},
    allow_blank: true

  validates :download_size, :support_contact_name, :supported_languages,
            :security_session_lifetime, :security_cloud_vendor, :security_policy_url,
            :security_sla_url,
    length: { maximum: 255 }

  validates :license_text, :security_text,
    length: { maximum: 65535 }

  validates :icon,
    presence: true,
    length: { maximum: 65535 }

  validates :tool_review_url,
            uri: true

  validates :privacy_url,
            uri: true

  after_validation :log_errors, :if => Proc.new {|m| m.errors}


  def log_errors
    Rails.logger.info self.errors.full_messages.join("\n")
  end

  before_save do
    ['icon'].each { |column| self[column].present? || self[column] = nil }
    NULL_IF_BLANK_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  after_commit do
    remove_from_index!
    add_to_index! if self.enabled
  end

  after_destroy do
    remove_from_index!
  end

  # This runs validations in the context of the app. Without it, the validations in app_lti_config
  # run, but the error message context gets overridden resulting in some error messages with bad UX.
  # It means the app_lti_config validations run twice. This could probably be avoided if admin/apps_controller
  # was modified to update app_lti_configs through the app (i.e., through ActiveRecord convention)
  # instead of deleting and adding new rows in the controller.
  accepts_nested_attributes_for :app_lti_configs

  def icon_tag
    if self.icon
      raw "<img src='#{self.icon.gsub /'/, '\\\''}' alt=''>"
    else
      #$('<span>').html(app.title.charAt(0)).appendTo($imgContainer);
      raw "<div class='letter-icon'><span>#{self.title[0,1]}</span></div>"
    end
  end

  def formatted_description
    unless description.index('<').nil?
      sanitize description, tags: %w(h1 h2 h3 h4 h5 h6 p ul ol li strong em b i u), attributes: []
    else
      simple_format description
    end
  end

  def average_rating
    total = 0
    app_ratings.each { |rating| total = total + rating.score }
    total.to_f / app_ratings.count
  end

  def originated?
    self.casa_in_payload.nil?
  end

  def payload_id
    (self.casa_id ? self.casa_id : self.id).to_s
  end

  def payload_originator_id
    (self.casa_originator_id ? self.casa_originator_id : Rails.application.config.casa[:engine][:uuid]).to_s
  end

  def has_security_properties_set?
    (security_uses_https.present? or
      security_uses_additional_encryption.present? or
      security_requires_cookies.present? or
      security_requires_third_party_cookies.present? or
      security_session_lifetime.present? or
      security_cloud_vendor.present? or
      security_policy_url.present? or
      security_sla_url.present? or
      security_text.present?)
  end

  def has_android_properties_set?
    (android_app_package.present? or
        android_app_scheme.present? or
        android_app_action.present? or
        android_app_category.present? or
        android_app_component.present?)
  end

  def has_ios_properties_set?
    (ios_app_id.present? or
      ios_app_scheme.present? or
      ios_app_path.present? or
      ios_app_affiliate_data.present?)
  end

  def has_licensing_properties_set?
    (license_is_free.present? or
      license_is_paid.present? or
      license_is_recharge.present? or
      license_is_by_seat.present? or
      license_is_subscription.present? or
      license_is_ad_supported.present? or
      license_is_other.present? or
      license_text.present? )
  end

  def has_security_properties_set?
    (security_uses_https.present? or
      security_uses_additional_encryption.present? or
      security_requires_cookies.present? or
      security_requires_third_party_cookies.present? or
      security_session_lifetime.present? or
      security_cloud_vendor.present? or
      security_policy_url.present? or
      security_sla_url.present? or
      security_text.present? )
  end

  def has_student_data_properties_set?
    (student_data_stores_local_data.present? or
      student_data_requires_account.present? or
      student_data_has_opt_in_for_data_collection.present? or
      student_data_has_opt_out_for_data_collection.present? or
      student_data_shows_eula.present? or
      student_data_is_app_externally_hosted.present? or
      student_data_stores_pii.present? )
  end

  def is_valid_review_status?(value)
    (value.eql?(RECOMMENDED_FOR_USE) || value.eql?(USE_WITH_CAUTION) || value.eql?(NOT_RECOMMENDED) || value.eql?(IN_PROGRESS))
  end

  def image_for_review_status(status)
    if status == RECOMMENDED_FOR_USE
      return '/assets/infobar_recommended_for_use.png'
    elsif status == USE_WITH_CAUTION
      return '/assets/infobar_use_with_caution.png'
    elsif status == NOT_RECOMMENDED
      return '/assets/infobar_not_recommended.png'
    elsif status == IN_PROGRESS
      return '/assets/infobar_in_progress.png'
    else
      return '/assets/infobar_dash.png'
    end
  end

  def title_text_for_review_status(status)
    if status == RECOMMENDED_FOR_USE
      return 'Recommended for use.'
    elsif status == USE_WITH_CAUTION
      return 'Use with caution.'
    elsif status == NOT_RECOMMENDED
      return 'Not recommended.'
    elsif status == IN_PROGRESS
      return 'Review in progress.'
    else
      return 'A review has not yet occurred.'
    end
  end

  def image_tag_for_review_status(status)
    "<img src=\"#{image_for_review_status(status)}\" title=\"#{title_text_for_review_status(status)}\">"
  end

  def url_for_wcag(wcag)
    Rails.application.config.wcag_urls[wcag]
  end

  def wcag_success_critereon_string_for(id)
    "#{id} - #{Rails.application.config.wcag_success_critereon_descriptions[id]}"
  end

  def wcag_success_critereon_text_only_for(id)
    Rails.application.config.wcag_success_critereon_descriptions[id]
  end

  def lti_versions_supported
    versions = Array.new
    app_lti_configs.each { | config |
      versions << config.lti_version unless config.lti_version.blank? or versions.include? config.lti_version
    }
    versions.join(',')
  end

  def lis_outcomes_supported?
    app_lti_configs.each { | config |
      if config.lti_lis_outcomes != 'no'
        return true
      end
    }
    return false
  end

  def has_lti_conformance_info?
    app_lti_configs.each { | config |
      if config.lti_ims_global_registration_number or config.lti_ims_global_conformance_date or config.lti_ims_global_registration_link
        return true
      end
    }
    return false
  end

  def caliper_supported_metric_profiles
    if caliper_metric_profiles.present?
      profiles = Array.new
      JSON.parse(caliper_metric_profiles)['metric_profiles'].each{ | profile_object |
        profiles << profile_object['profile']
      }
      profiles
    end
  end

  def actions_for_supported_metric_profile(profile)
    if caliper_metric_profiles.present?
      JSON.parse(caliper_metric_profiles)['metric_profiles'].each{ | profile_object |
        return profile_object['actions'].join(', ') if profile_object['profile'] == profile
      }
    end
  end

  # Returns the Launch URL for the default LTI Config, if one exists
  def default_lti_launch_url
    app_lti_configs.try(:each){ |config| return config.lti_launch_url if config.lti_default }
    return nil
  end

  # Returns the default LTI Config, if one exists
  def default_lti_config
    app_lti_configs.try(:each){ |config| return config if config.lti_default }
    return nil
  end

  def lti_config_for_lti_consumer(lti_consumer_id)
    if lti_consumer_id
      app_lti_configs.try(:each){ |config|
        return config if config.lti_consumer_id == lti_consumer_id
      }
    end
    return nil
  end

  def caliper_attribute_is_valid

    if self.caliper

      if self.caliper_metric_profiles.nil? or self.caliper_metric_profiles.empty?
        errors.add(:caliper, '- At least one Metric Profile should be configured if the Caliper checkbox is checked.')
        return
      end

      unless self.caliper_metric_profiles.nil? or self.caliper_metric_profiles.empty?
        error_text = fully_validate_against_json_schema('config/json-schema/caliper-schema.json', self.caliper_metric_profiles)

        unless error_text.nil? or error_text.empty?
          Rails.logger.info('caliper_metric_profile property failed schema validation: ' + error_text.map { |s| "'#{s}'" }.join(' '))

          errors.add(:caliper, ' - The Caliper Metric Profiles JSON did not pass schema validation. The Caliper attribute' +
                                 ' schema can be found here: http://imsglobal.github.io/casa-protocol/#Attributes/Interoperability:caliper')
        else

          json_as_map = JSON.parse(caliper_metric_profiles)

          json_as_map['metric_profiles'].each do | p |
            if p['profile'].blank?
              errors.add(:caliper, ' - The Caliper Metric Profiles cannot contain empty profiles.')
            end
          end

          if errors.empty?
            # Remove any pretty printing from the JSON
            self.caliper_metric_profiles = JSON.generate(json_as_map)
          end
        end
      end

      unless self.caliper_ims_global_certifications.nil? or self.caliper_ims_global_certifications.empty?
        error_text = fully_validate_against_json_schema('config/json-schema/caliper-schema.json', self.caliper_ims_global_certifications)

        unless error_text.nil? or error_text.empty?
          Rails.logger.info('caliper_ims_global_certifications failed schema validation: ' + error_text.map { |s| "'#{s}'" }.join(' '))

          errors.add(:caliper, ' - The Caliper IMS Global Certifications JSON did not pass schema validation. The Caliper attribute' +
                                 ' schema can be found here: http://imsglobal.github.io/casa-protocol/#Attributes/Interoperability:caliper')
        else
          json_as_map = JSON.parse(caliper_ims_global_certifications)

          json_as_map['ims_global_certifications'].each do | c |
            c['metric_profiles'].each do | mp |
              if mp.blank?
                errors.add(:caliper, ' - The Caliper IMS Global Certifications cannot contain empty metric profiles')
              end
            end
            if c['registration_number'].blank?
              errors.add(:caliper, ' - The Caliper IMS Global Certifications cannot contain empty registration numbers.')
            end
            if c['conformance_date'].blank?
              errors.add(:caliper, ' - The Caliper IMS Global Certifications cannot contain empty conformance dates.')
            end
          end

          if errors.empty?
            # Remove any pretty printing from the JSON
            self.caliper_ims_global_certifications = JSON.generate(json_as_map)
          end

        end
      end

    else

      # Reset the detailed properties
      self.caliper_metric_profiles = nil
      self.caliper_ims_global_certifications = nil

    end

  end

  def to_transit_payload

    if originated?

      payload = {
          'identity' => {
              'id' => payload_id,
              'originator_id' => payload_originator_id
          },
          'original' => {
              'uri' => self.uri,
              'share' => self.share,
              'propagate' => self.propagate,
              'timestamp' => self.updated_at.to_datetime.rfc3339,
              'use' => {},
              'require' => {}
          }
      }

      Casa::Payload.attributes_map.each do |type, mappings|
        mappings.each do |field, klass|
          key = klass.send :uuid
          if klass.respond_to?(:make_for) # use handler's mapping function to compute payload value from app value
            value = klass.make_for(self)
          else # directly copy value from app to payload
            value = self.send(field)
          end
          payload['original'][type][key] = value unless value.nil?
        end
      end

      payload

    else

      JSON.parse self.casa_in_payload

    end

  end

  def to_local_payload

    payload = {
        'identity' => {
            'id' => payload_id,
            'originator_id' => payload_originator_id
        },
        'attributes' => {
            'uri' => self.uri,
            'share' => self.share,
            'propagate' => self.propagate,
            'timestamp' => self.updated_at.to_datetime.rfc3339,
            'use' => {},
            'require' => {}
        }
    }

    Casa::Payload.attributes_map.each do |type, mappings|
      mappings.each do |field, klass|
        key = klass.send :name
        value = klass.respond_to?(:make_for) ? klass.make_for(self) : self.send(field)
        payload['attributes'][type][key] = value unless value.nil?
      end
    end

    payload

  end

  def to_content_item(lti_consumer_id)

    # 1. Check to see if there is an LTI Configuration that is bound to the LTI Consumer that
    # launched CASA on Rails. Use it if it exists.
    # 2. Else use the default LTI Configuration.
    # 3. Else generate the message manually from the app metadata.

    content_item = nil

    if self.lti
      lti_config = lti_config_for_lti_consumer lti_consumer_id

      unless lti_config
        lti_config = default_lti_config
      end

      content_item = lti_config.lti_content_item_message

      unless content_item
        content_item = {
          'title' => self.title.length > 0 ? self.title : 'Untitled',
          # The LTI launch URL is the only required LTI element in an LTI configuration
          'url' => lti_config.lti_launch_url,
          'mediaType' => 'application/vnd.ims.lti.v1.ltilink'
        }

        content_item['icon'] = { '@id' => self.icon } if self.icon and self.icon.length > 0
        content_item['custom'] = { 'official' => official }

        # Here the OAuth info for the tool is included. The assumption is that we are only generating a
        # Content-Item Message with these private values if the store itself has been launched by a trusted LTI Consumer.
        content_item['custom']['oauth_key'] = lti_config.lti_oauth_consumer_key if lti_config.lti_oauth_consumer_key
        content_item['custom']['oauth_secret'] = lti_config.lti_oauth_consumer_secret if lti_config.lti_oauth_consumer_secret
        content_item['custom']['registration_url'] = lti_config.lti_registration_url if lti_config.lti_registration_url
      else
        content_item = JSON.parse content_item
      end
    else
      content_item = {
        'title' => self.title.length > 0 ? self.title : 'Untitled',
        'url' => self.uri,
        'mediaType' => 'text/html'
      }
      content_item['text'] = self.description if self.description.length > 0
      content_item['icon'] = { '@id' => self.icon } if self.icon and self.icon.length > 0
      content_item['custom'] = { 'official' => official }
    end

    content_item
  end

  def add_to_index!

    return if elasticsearch_client.nil?

    elasticsearch_client.create index: Rails.application.config.elasticsearch_index,
                                type: 'local',
                                id: self.id,
                                body: to_local_payload

  end

  def remove_from_index!

    return if elasticsearch_client.nil?

    begin
      elasticsearch_client.delete index: Rails.application.config.elasticsearch_index,
                                  type: 'local',
                                  id: self.id

    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      # ES throws this error even though it successfully marks the document for deletion
    rescue => e
      Rails.logger.warn e.class.name + ' ' + e
    end

  end

  private

  def elasticsearch_client
    Rails.application.config.elasticsearch_client
  end

  class << self

    def where_identity identity

      return nil unless identity.include?(:id) and identity.include?(:originator_id)

      if identity[:originator_id] == Rails.application.config.casa[:engine][:uuid]
        App.where(casa_in_payload: nil,
                  share: true,
                  id: identity[:id]).first
      else
        App.where(share: true,
                  casa_id: identity[:id],
                  casa_originator_id: identity[:originator_id]).first
      end

    end

    def where_query_string qs

      return nil if elasticsearch_client.nil?

      res = elasticsearch_client.search index: Rails.application.config.elasticsearch_index,
                                        type: 'local',
                                        q: qs

      App.where id: res['hits']['hits'].map(){ |app| app['_id'] }

    end

    def where_query qb

      return nil if elasticsearch_client.nil?

      res = elasticsearch_client.search index: Rails.application.config.elasticsearch_index,
                                        type: 'local',
                                        body: qb

      App.where id: res['hits']['hits'].map(){ |app| app['_id'] }

    end

    def init_index!

      return if elasticsearch_client.nil?

      unless elasticsearch_client.indices.exists index: Rails.application.config.elasticsearch_index
        elasticsearch_client.indices.create index: Rails.application.config.elasticsearch_index, body: {}
      end

    end

    def drop_index!

      return if elasticsearch_client.nil?

      if elasticsearch_client.indices.exists index: Rails.application.config.elasticsearch_index
        elasticsearch_client.indices.delete index: Rails.application.config.elasticsearch_index
      end

    end

    private

    def elasticsearch_client
      Rails.application.config.elasticsearch_client
    end

  end

end
