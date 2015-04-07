module Casa
  class Payload

    cattr_reader :attributes_map

    @@attributes_map = {
        'use' => {
            Casa::Attribute::Title.name => Casa::Attribute::Title,
            Casa::Attribute::Description.name => Casa::Attribute::Description,
            Casa::Attribute::ShortDescription.name => Casa::Attribute::ShortDescription,
            Casa::Attribute::Categories.name => Casa::Attribute::Categories,
            Casa::Attribute::Tags.name => Casa::Attribute::Tags,
            Casa::Attribute::Author.name => Casa::Attribute::Author,
            Casa::Attribute::Organization.name => Casa::Attribute::Organization,
            Casa::Attribute::BrowserFeatures.name => Casa::Attribute::BrowserFeatures,
            Casa::Attribute::AndroidApp.name => Casa::Attribute::AndroidApp,
            Casa::Attribute::IosApp.name => Casa::Attribute::IosApp,
            Casa::Attribute::Lti.name => Casa::Attribute::Lti,
            Casa::Attribute::Privacy.name => Casa::Attribute::Privacy,
            Casa::Attribute::PrivacyUrl.name => Casa::Attribute::PrivacyUrl,
            Casa::Attribute::AccessibilityUrl.name => Casa::Attribute::AccessibilityUrl,
            Casa::Attribute::VpatUrl.name => Casa::Attribute::VpatUrl
        },
        'require' => {
            # ..
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
