class AppPrivacyPolicy < ActiveRecord::Base

  has_many :apps

  class << self

    def classifications
      {
          'session' => 'Cookies and other anonymous data used to track an individual\'s interaction with the system',
          'context' => 'The context within which a user is accessing the system',
          'name' => false,
          'contact' => 'Email address, phone number, mailing address, etc.',
          'preferences' => 'User-specific settings in regards to how the app should behave for them',
          'activity' => 'Information about what the user is doing in the system.',
          'assessment' => 'Assessment information such as grades or fulfilled competencies.',
          'location' => 'Geographic information such as geo-locating IP address or GPS coordinates.',
          'demographic' => 'Demographic information such as race, ethnicity and gender.',
          'financial' => 'Financial information such as income, employment records, credit info, etc.',
          'health' => 'Personally-identifiable health information',
          'purchasing' => 'Credit card numbers, check numbers, other forms of payment, etc.',
          'govid' => 'Drivers license, social security number and/or other forms of government ID.'
      }
    end

    def types
      {
          'system' => 'Information retained for debugging the app and supporting users upon their request.',
          'research' => 'Information retained to guide the development of app features and improvements.',
          'profiling' => 'Information retained to profile users and tweak their experiences.',
          'marketing' => 'Information retained to market the product or other products to the user.',
          'context' => 'Information shared with other users in the same context (such as as LTI course instance).',
          'others' => 'Information shared with other companies, organizations, etc. through private channels.',
          'public' => 'Information shared publicly.'
      }
    end

  end

end