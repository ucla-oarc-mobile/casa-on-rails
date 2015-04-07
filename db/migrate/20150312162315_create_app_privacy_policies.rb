class CreateAppPrivacyPolicies < ActiveRecord::Migration
  def change
    create_table :app_privacy_policies do |t|

      t.string :session_system, default: 'true', limit: 15, null: false
      t.string :session_research, default: 'true', limit: 15, null: false
      t.string :session_profiling, default: 'false', limit: 15, null: false
      t.string :session_marketing, default: 'false', limit: 15, null: false
      t.string :session_context, default: 'false', limit: 15, null: false
      t.string :session_others, default: 'false', limit: 15, null: false
      t.string :session_public, default: 'false', limit: 15, null: false

      t.string :context_system, default: 'true', limit: 15, null: false
      t.string :context_research, default: 'true', limit: 15, null: false
      t.string :context_profiling, default: 'false', limit: 15, null: false
      t.string :context_marketing, default: 'false', limit: 15, null: false
      t.string :context_context, default: 'false', limit: 15, null: false
      t.string :context_others, default: 'false', limit: 15, null: false
      t.string :context_public, default: 'false', limit: 15, null: false

      t.string :name_system, default: 'true', limit: 15, null: false
      t.string :name_research, default: 'true', limit: 15, null: false
      t.string :name_profiling, default: 'false', limit: 15, null: false
      t.string :name_marketing, default: 'false', limit: 15, null: false
      t.string :name_context, default: 'false', limit: 15, null: false
      t.string :name_others, default: 'false', limit: 15, null: false
      t.string :name_public, default: 'false', limit: 15, null: false

      t.string :contact_system, default: 'true', limit: 15, null: false
      t.string :contact_research, default: 'true', limit: 15, null: false
      t.string :contact_profiling, default: 'false', limit: 15, null: false
      t.string :contact_marketing, default: 'false', limit: 15, null: false
      t.string :contact_context, default: 'false', limit: 15, null: false
      t.string :contact_others, default: 'false', limit: 15, null: false
      t.string :contact_public, default: 'false', limit: 15, null: false

      t.string :preferences_system, default: 'true', limit: 15, null: false
      t.string :preferences_research, default: 'true', limit: 15, null: false
      t.string :preferences_profiling, default: 'false', limit: 15, null: false
      t.string :preferences_marketing, default: 'false', limit: 15, null: false
      t.string :preferences_context, default: 'false', limit: 15, null: false
      t.string :preferences_others, default: 'false', limit: 15, null: false
      t.string :preferences_public, default: 'false', limit: 15, null: false

      t.string :activity_system, default: 'true', limit: 15, null: false
      t.string :activity_research, default: 'true', limit: 15, null: false
      t.string :activity_profiling, default: 'false', limit: 15, null: false
      t.string :activity_marketing, default: 'false', limit: 15, null: false
      t.string :activity_context, default: 'false', limit: 15, null: false
      t.string :activity_others, default: 'false', limit: 15, null: false
      t.string :activity_public, default: 'false', limit: 15, null: false

      t.string :assessment_system, default: 'true', limit: 15, null: false
      t.string :assessment_research, default: 'true', limit: 15, null: false
      t.string :assessment_profiling, default: 'false', limit: 15, null: false
      t.string :assessment_marketing, default: 'false', limit: 15, null: false
      t.string :assessment_context, default: 'false', limit: 15, null: false
      t.string :assessment_others, default: 'false', limit: 15, null: false
      t.string :assessment_public, default: 'false', limit: 15, null: false

      t.string :location_system, default: 'true', limit: 15, null: false
      t.string :location_research, default: 'true', limit: 15, null: false
      t.string :location_profiling, default: 'false', limit: 15, null: false
      t.string :location_marketing, default: 'false', limit: 15, null: false
      t.string :location_context, default: 'false', limit: 15, null: false
      t.string :location_others, default: 'false', limit: 15, null: false
      t.string :location_public, default: 'false', limit: 15, null: false

      t.string :demographic_system, default: 'true', limit: 15, null: false
      t.string :demographic_research, default: 'true', limit: 15, null: false
      t.string :demographic_profiling, default: 'false', limit: 15, null: false
      t.string :demographic_marketing, default: 'false', limit: 15, null: false
      t.string :demographic_context, default: 'false', limit: 15, null: false
      t.string :demographic_others, default: 'false', limit: 15, null: false
      t.string :demographic_public, default: 'false', limit: 15, null: false

      t.string :financial_system, default: 'false', limit: 15, null: false
      t.string :financial_research, default: 'false', limit: 15, null: false
      t.string :financial_profiling, default: 'false', limit: 15, null: false
      t.string :financial_marketing, default: 'false', limit: 15, null: false
      t.string :financial_context, default: 'false', limit: 15, null: false
      t.string :financial_others, default: 'false', limit: 15, null: false
      t.string :financial_public, default: 'false', limit: 15, null: false

      t.string :health_system, default: 'false', limit: 15, null: false
      t.string :health_research, default: 'false', limit: 15, null: false
      t.string :health_profiling, default: 'false', limit: 15, null: false
      t.string :health_marketing, default: 'false', limit: 15, null: false
      t.string :health_context, default: 'false', limit: 15, null: false
      t.string :health_others, default: 'false', limit: 15, null: false
      t.string :health_public, default: 'false', limit: 15, null: false

      t.string :purchasing_system, default: 'false', limit: 15, null: false
      t.string :purchasing_research, default: 'false', limit: 15, null: false
      t.string :purchasing_profiling, default: 'false', limit: 15, null: false
      t.string :purchasing_marketing, default: 'false', limit: 15, null: false
      t.string :purchasing_context, default: 'false', limit: 15, null: false
      t.string :purchasing_others, default: 'false', limit: 15, null: false
      t.string :purchasing_public, default: 'false', limit: 15, null: false

      t.string :govid_system, default: 'false', limit: 15, null: false
      t.string :govid_research, default: 'false', limit: 15, null: false
      t.string :govid_profiling, default: 'false', limit: 15, null: false
      t.string :govid_marketing, default: 'false', limit: 15, null: false
      t.string :govid_context, default: 'false', limit: 15, null: false
      t.string :govid_others, default: 'false', limit: 15, null: false
      t.string :govid_public, default: 'false', limit: 15, null: false

    end
  end
end
