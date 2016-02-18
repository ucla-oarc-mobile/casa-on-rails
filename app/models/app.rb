
class App < ActiveRecord::Base
  include AttributeConcern,
          ActiveModel::Validations,
          ActionView::Helpers::SanitizeHelper,
          ActionView::Helpers::TextHelper

  NULL_IF_BLANK_ATTRS = %w( icon description short_description privacy_url accessibility_url vpat_url wcag_url acceptable ios_app_id ios_app_scheme ios_app_path ios_app_affiliate_data android_app_package android_app_scheme android_app_action android_app_category android_app_component download_size supported_languages security_session_lifetime security_cloud_vendor security_policy_url security_sla_url security_text license_text support_contact_name support_contact_email primary_contact_name primary_contact_email )

  class LTIExistenceValidator < ActiveModel::Validator
    def validate(record)
      if record.lti && record.app_lti_configs.empty?
        record.errors.add(:lti, 'Interoperability - At least one LTI Configuration is required if "Supports LTI" is checked.')
      end
    end
  end

  class LTIDefaultValidator < ActiveModel::Validator
    def validate(record)
      count = 0
      record.app_lti_configs.each { |c|  count += 1 if c.lti_default } unless record.app_lti_configs.empty?
      if count > 1
        record.errors.add(:lti, 'Only one LTI configuration can be set as the default.')
      end
      if record.app_lti_configs.count >= 1 && count == 0
        record.errors.add(:lti, 'When multiple LTI configurations are being created, one of them must be set as the default.')
      end
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
      joins('LEFT OUTER JOIN `app_launch_methods` ON `apps`.`id` = `app_launch_methods`.`app_id`').where('restrict_launch = 0 OR `app_launch_methods`.`method` = :method', { method: m })
    end
  }

  validates_with LTIExistenceValidator
  validates_with LTIDefaultValidator

  validate :caliper_attribute_is_valid

  validates :title,
    presence: true,
    length: { minimum: 1 }

  validates :support_contact_email,
    length: { minimum: 6, maximum: 255},
    allow_blank: true

  validates :download_size, :support_contact_name, :supported_languages,
            :security_session_lifetime, :security_cloud_vendor, :security_policy_url ,
            :security_sla_url,
    length: { maximum: 255 }

  validates :icon, :license_text, :security_text,
    length: { maximum: 65535 }

  before_save do
    ['icon'].each { |column| self[column].present? || self[column] = nil }
    NULL_IF_BLANK_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end

  after_save do
    remove_from_index!
    add_to_index! if self.enabled
  end

  before_destroy do
    remove_from_index!
  end

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

  def url_for_wcag(wcag)
    Rails.application.config.wcag_urls[wcag]
  end

  def lti_versions_supported
    versions = Array.new
    app_lti_configs.each { | config |
      versions << config.lti_version unless config.lti_version.blank?
    }
    versions.join(',')
  end

  def lis_outcomes_supported
    app_lti_configs.each { | config |
      if config.lti_lis_outcomes != 'no'
        return true
      end
    }
    false
  end

  def has_lti_conformance_info
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
    else
      nil
    end
  end

  def actions_for_supported_metric_profile(profile)
    if caliper_metric_profiles.present?
      JSON.parse(caliper_metric_profiles)['metric_profiles'].each{ | profile_object |
        return profile_object['actions'].join(', ') if profile_object['profile'] == profile
      }
    else
      nil
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

  def to_content_item

    content_item = {
      'title' => self.title.length > 0 ? self.title : 'Untitled',
      'url' => self.uri
    }

    if self.lti
      content_item['mediaType'] = 'application/vnd.ims.lti.v1.ltilink'
      content_item['url'] = self.lti_launch_url if self.lti_launch_url
    else
      content_item['mediaType'] = 'text/html'
    end

    content_item['text'] = self.description if self.description.length > 0
    content_item['icon'] = { '@id' => self.icon } if self.icon and self.icon.length > 0

    content_item

  end

  def add_to_index!

    return if elasticsearch_client.nil?

    elasticsearch_client.create index: Rails.application.config.elasticsearch_index,
                                type: 'local',
                                id: self.id,
                                body: to_local_payload

  end

  def caliper_attribute_is_valid

    if self.caliper

      if self.caliper_metric_profiles.nil? or self.caliper_metric_profiles.empty?
        errors.add(:interoperability, '-- At least one Metric Profile should be configured if the Caliper checkbox is checked.')
        return
      end

      unless self.caliper_metric_profiles.nil? or self.caliper_metric_profiles.empty?
        error_text = fully_validate_against_json_schema('config/json-schema/caliper-schema.json', self.caliper_metric_profiles)

        unless error_text.nil? or error_text.empty?
          Rails.logger.info('caliper_metric_profile property failed schema validation: ' + error_text.map { |s| "'#{s}'" }.join(' '))

          errors.add(:interoperability, ' -- The Caliper Metric Profiles JSON did not pass schema validation. The Caliper attribute' +
           ' schema can be found here: http://imsglobal.github.io/casa-protocol/#Attributes/Interoperability:caliper')
        else

          json_as_map = JSON.parse(caliper_metric_profiles)

          json_as_map['metric_profiles'].each do | p |
              if p['profile'].blank?
                errors.add(:interoperability, ' -- The Caliper Metric Profiles cannot contain empty profiles.')
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

          errors.add(:interoperability, ' -- The Caliper IMS Global Certifications JSON did not pass schema validation. The Caliper attribute' +
                                          ' schema can be found here: http://imsglobal.github.io/casa-protocol/#Attributes/Interoperability:caliper')
        else
          json_as_map = JSON.parse(caliper_ims_global_certifications)

          json_as_map['ims_global_certifications'].each do | c |
            c['metric_profiles'].each do | mp |
              if mp.blank?
                errors.add(:interoperability, ' -- The Caliper IMS Global Certifications cannot contain empty metric profiles')
              end
            end
            if c['registration_number'].blank?
              errors.add(:interoperability, ' -- The Caliper IMS Global Certifications cannot contain empty registration numbers.')
            end
            if c['conformance_date'].blank?
              errors.add(:interoperability, ' -- The Caliper IMS Global Certifications cannot contain empty conformance dates.')
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

  def remove_from_index!

    return if elasticsearch_client.nil?

    begin
      elasticsearch_client.delete index: Rails.application.config.elasticsearch_index,
                                  type: 'local',
                                  id: self.id
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      # fail silently -- this is okay!
    rescue => e
      puts e.class.name
      puts e
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
