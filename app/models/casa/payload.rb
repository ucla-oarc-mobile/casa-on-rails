module Casa
  class Payload

    cattr_reader :attributes_map

    @@attributes_map = {
        'use' => {
            Casa::Attribute::Title.name => Casa::Attribute::Title,
            Casa::Attribute::Description.name => Casa::Attribute::Description,
            Casa::Attribute::ShortDescription.name => Casa::Attribute::ShortDescription,
            Casa::Attribute::Icon.name => Casa::Attribute::Icon,
            Casa::Attribute::Categories.name => Casa::Attribute::Categories,
            Casa::Attribute::Tags.name => Casa::Attribute::Tags,
            Casa::Attribute::Author.name => Casa::Attribute::Author,
            Casa::Attribute::Organization.name => Casa::Attribute::Organization,
            Casa::Attribute::BrowserFeatures.name => Casa::Attribute::BrowserFeatures,
            Casa::Attribute::AndroidApp.name => Casa::Attribute::AndroidApp,
            Casa::Attribute::IosApp.name => Casa::Attribute::IosApp,
            Casa::Attribute::Lti.name => Casa::Attribute::Lti,
            Casa::Attribute::Caliper.name => Casa::Attribute::Caliper,
            Casa::Attribute::Privacy.name => Casa::Attribute::Privacy,
            Casa::Attribute::PrivacyUrl.name => Casa::Attribute::PrivacyUrl,
            Casa::Attribute::AccessibilityUrl.name => Casa::Attribute::AccessibilityUrl,
            Casa::Attribute::WcagUrl.name => Casa::Attribute::WcagUrl,
            Casa::Attribute::WcagGuidelines.name => Casa::Attribute::WcagGuidelines,
            Casa::Attribute::SupportContact.name => Casa::Attribute::SupportContact,
            Casa::Attribute::AdminContact.name => Casa::Attribute::AdminContact,
            Casa::Attribute::Competencies.name => Casa::Attribute::Competencies,
            Casa::Attribute::Licensing.name => Casa::Attribute::Licensing,
            Casa::Attribute::Security.name => Casa::Attribute::Security,
            Casa::Attribute::StudentData.name => Casa::Attribute::StudentData,
            Casa::Attribute::Features.name => Casa::Attribute::Features,
            Casa::Attribute::DefaultAppOrder.name => Casa::Attribute::DefaultAppOrder,
            Casa::Attribute::IconUrl.name => Casa::Attribute::IconUrl
        },
        'require' => {
        }
    }

    class << self

      def attribute_for_uuid type, value

        _, attr = attributes_map[type].find { |_,attr| attr.uuid == value }
        attr

      end

      include Casa::Payload::ClassMethods::TranslateIn
      include Casa::Payload::ClassMethods::SquashIn
      include Casa::Payload::ClassMethods::FilterIn

    end

  end
end
