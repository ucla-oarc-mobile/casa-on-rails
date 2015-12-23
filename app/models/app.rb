
class App < ActiveRecord::Base
  include AttributeConcern,
          ActiveModel::Validations,
          ActionView::Helpers::SanitizeHelper,
          ActionView::Helpers::TextHelper

  NULL_IF_BLANK_ATTRS = %w( icon description short_description privacy_url accessibility_url vpat_url acceptable lti_configuration_url lti_registration_url lti_outcomes ios_app_id ios_app_scheme ios_app_path ios_app_affiliate_data android_app_package android_app_scheme android_app_action android_app_category android_app_component lti_launch_url )

  class VarChar255Validator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << 'must contain 255 characters or fewer.' unless (value.to_s.size <= 255)
    end
  end

  class TextBlobValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << 'is too large and would be truncated if saved. Please reduce the size to less than 64KB and submit again.' unless (value.to_s.size <= 65535)
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
  has_many :app_lti_versions, :dependent => :destroy
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

  validate :caliper_attribute_is_valid

  validates :title,
    presence: true,
    length: { minimum: 1 }

  validates :icon, :license_text, :security_text,
    :textBlob => true

  validates :support_contact_email,
    length: { minimum: 6, maximum: 255, message: ' -- Please provide a valid email address.'},
    allow_blank: true

  validates :download_size, :support_contact_name, :supported_languages,
            :security_session_lifetime, :security_cloud_vendor, :security_policy_url ,
            :security_sla_url,
   :varChar255 => true

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
