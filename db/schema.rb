# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160217231618) do

  create_table "app_authors", force: true do |t|
    t.integer "app_id"
    t.string  "name"
    t.string  "email"
    t.string  "website"
  end

  create_table "app_browser_features", force: true do |t|
    t.integer "app_id"
    t.string  "feature"
    t.string  "level"
  end

  add_index "app_browser_features", ["feature"], name: "index_app_browser_features_on_feature", using: :btree
  add_index "app_browser_features", ["level"], name: "index_app_browser_features_on_level", using: :btree

  create_table "app_competencies", force: true do |t|
    t.integer  "app_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_features", force: true do |t|
    t.integer  "app_id"
    t.string   "feature_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_launch_methods", force: true do |t|
    t.integer  "app_id"
    t.string   "method"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_lti_configs", force: true do |t|
    t.integer  "app_id"
    t.string   "lti_launch_url"
    t.text     "lti_launch_params"
    t.string   "lti_registration_url"
    t.string   "lti_configuration_url"
    t.text     "lti_content_item_message"
    t.string   "lti_lis_outcomes"
    t.string   "lti_version"
    t.string   "lti_ims_global_registration_number"
    t.string   "lti_ims_global_conformance_date"
    t.string   "lti_ims_global_registration_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "lti_default"
  end

  create_table "app_media_requirements", force: true do |t|
    t.integer "app_id"
    t.boolean "color"
    t.string  "max_aspect_ratio"
    t.string  "max_color"
    t.string  "max_device_height"
    t.string  "max_device_width"
    t.string  "max_height"
    t.string  "max_resolution"
    t.string  "max_width"
    t.string  "min_aspect_ratio"
    t.string  "min_color"
    t.string  "min_device_height"
    t.string  "min_device_width"
    t.string  "min_height"
    t.string  "min_resolution"
    t.string  "min_width"
  end

  create_table "app_organizations", force: true do |t|
    t.integer "app_id"
    t.string  "name"
    t.string  "website"
  end

  create_table "app_out_peer_permissions", force: true do |t|
    t.integer  "app_id"
    t.integer  "out_peer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_privacy_policies", force: true do |t|
    t.string "session_system",        limit: 15, default: "true",  null: false
    t.string "session_research",      limit: 15, default: "true",  null: false
    t.string "session_profiling",     limit: 15, default: "false", null: false
    t.string "session_marketing",     limit: 15, default: "false", null: false
    t.string "session_context",       limit: 15, default: "false", null: false
    t.string "session_others",        limit: 15, default: "false", null: false
    t.string "session_public",        limit: 15, default: "false", null: false
    t.string "context_system",        limit: 15, default: "true",  null: false
    t.string "context_research",      limit: 15, default: "true",  null: false
    t.string "context_profiling",     limit: 15, default: "false", null: false
    t.string "context_marketing",     limit: 15, default: "false", null: false
    t.string "context_context",       limit: 15, default: "false", null: false
    t.string "context_others",        limit: 15, default: "false", null: false
    t.string "context_public",        limit: 15, default: "false", null: false
    t.string "name_system",           limit: 15, default: "true",  null: false
    t.string "name_research",         limit: 15, default: "true",  null: false
    t.string "name_profiling",        limit: 15, default: "false", null: false
    t.string "name_marketing",        limit: 15, default: "false", null: false
    t.string "name_context",          limit: 15, default: "false", null: false
    t.string "name_others",           limit: 15, default: "false", null: false
    t.string "name_public",           limit: 15, default: "false", null: false
    t.string "contact_system",        limit: 15, default: "true",  null: false
    t.string "contact_research",      limit: 15, default: "true",  null: false
    t.string "contact_profiling",     limit: 15, default: "false", null: false
    t.string "contact_marketing",     limit: 15, default: "false", null: false
    t.string "contact_context",       limit: 15, default: "false", null: false
    t.string "contact_others",        limit: 15, default: "false", null: false
    t.string "contact_public",        limit: 15, default: "false", null: false
    t.string "preferences_system",    limit: 15, default: "true",  null: false
    t.string "preferences_research",  limit: 15, default: "true",  null: false
    t.string "preferences_profiling", limit: 15, default: "false", null: false
    t.string "preferences_marketing", limit: 15, default: "false", null: false
    t.string "preferences_context",   limit: 15, default: "false", null: false
    t.string "preferences_others",    limit: 15, default: "false", null: false
    t.string "preferences_public",    limit: 15, default: "false", null: false
    t.string "activity_system",       limit: 15, default: "true",  null: false
    t.string "activity_research",     limit: 15, default: "true",  null: false
    t.string "activity_profiling",    limit: 15, default: "false", null: false
    t.string "activity_marketing",    limit: 15, default: "false", null: false
    t.string "activity_context",      limit: 15, default: "false", null: false
    t.string "activity_others",       limit: 15, default: "false", null: false
    t.string "activity_public",       limit: 15, default: "false", null: false
    t.string "assessment_system",     limit: 15, default: "true",  null: false
    t.string "assessment_research",   limit: 15, default: "true",  null: false
    t.string "assessment_profiling",  limit: 15, default: "false", null: false
    t.string "assessment_marketing",  limit: 15, default: "false", null: false
    t.string "assessment_context",    limit: 15, default: "false", null: false
    t.string "assessment_others",     limit: 15, default: "false", null: false
    t.string "assessment_public",     limit: 15, default: "false", null: false
    t.string "location_system",       limit: 15, default: "true",  null: false
    t.string "location_research",     limit: 15, default: "true",  null: false
    t.string "location_profiling",    limit: 15, default: "false", null: false
    t.string "location_marketing",    limit: 15, default: "false", null: false
    t.string "location_context",      limit: 15, default: "false", null: false
    t.string "location_others",       limit: 15, default: "false", null: false
    t.string "location_public",       limit: 15, default: "false", null: false
    t.string "demographic_system",    limit: 15, default: "true",  null: false
    t.string "demographic_research",  limit: 15, default: "true",  null: false
    t.string "demographic_profiling", limit: 15, default: "false", null: false
    t.string "demographic_marketing", limit: 15, default: "false", null: false
    t.string "demographic_context",   limit: 15, default: "false", null: false
    t.string "demographic_others",    limit: 15, default: "false", null: false
    t.string "demographic_public",    limit: 15, default: "false", null: false
    t.string "financial_system",      limit: 15, default: "false", null: false
    t.string "financial_research",    limit: 15, default: "false", null: false
    t.string "financial_profiling",   limit: 15, default: "false", null: false
    t.string "financial_marketing",   limit: 15, default: "false", null: false
    t.string "financial_context",     limit: 15, default: "false", null: false
    t.string "financial_others",      limit: 15, default: "false", null: false
    t.string "financial_public",      limit: 15, default: "false", null: false
    t.string "health_system",         limit: 15, default: "false", null: false
    t.string "health_research",       limit: 15, default: "false", null: false
    t.string "health_profiling",      limit: 15, default: "false", null: false
    t.string "health_marketing",      limit: 15, default: "false", null: false
    t.string "health_context",        limit: 15, default: "false", null: false
    t.string "health_others",         limit: 15, default: "false", null: false
    t.string "health_public",         limit: 15, default: "false", null: false
    t.string "purchasing_system",     limit: 15, default: "false", null: false
    t.string "purchasing_research",   limit: 15, default: "false", null: false
    t.string "purchasing_profiling",  limit: 15, default: "false", null: false
    t.string "purchasing_marketing",  limit: 15, default: "false", null: false
    t.string "purchasing_context",    limit: 15, default: "false", null: false
    t.string "purchasing_others",     limit: 15, default: "false", null: false
    t.string "purchasing_public",     limit: 15, default: "false", null: false
    t.string "govid_system",          limit: 15, default: "false", null: false
    t.string "govid_research",        limit: 15, default: "false", null: false
    t.string "govid_profiling",       limit: 15, default: "false", null: false
    t.string "govid_marketing",       limit: 15, default: "false", null: false
    t.string "govid_context",         limit: 15, default: "false", null: false
    t.string "govid_others",          limit: 15, default: "false", null: false
    t.string "govid_public",          limit: 15, default: "false", null: false
  end

  create_table "app_ratings", force: true do |t|
    t.integer  "app_id"
    t.integer  "user_id"
    t.integer  "score"
    t.text     "review"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_tags", force: true do |t|
    t.integer  "app_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_wcag_guidelines", force: true do |t|
    t.integer  "app_id"
    t.string   "guideline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", force: true do |t|
    t.string   "title"
    t.text     "uri"
    t.text     "icon"
    t.text     "description"
    t.boolean  "enabled",                                      default: false
    t.boolean  "share",                                        default: true
    t.boolean  "propagate",                                    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "casa_in_payload"
    t.string   "casa_id"
    t.string   "casa_originator_id"
    t.string   "short_description"
    t.integer  "app_privacy_policy_id"
    t.text     "privacy_url"
    t.text     "accessibility_url"
    t.text     "vpat_url"
    t.text     "acceptable"
    t.text     "ios_app_id"
    t.text     "ios_app_scheme"
    t.text     "ios_app_path"
    t.text     "ios_app_affiliate_data"
    t.text     "android_app_package"
    t.text     "android_app_scheme"
    t.text     "android_app_action"
    t.text     "android_app_category"
    t.text     "android_app_component"
    t.boolean  "lti",                                          default: false
    t.boolean  "restrict",                                     default: false
    t.boolean  "mobile_support",                               default: false
    t.boolean  "restrict_launch",                              default: false
    t.integer  "created_by"
    t.boolean  "official",                                     default: false
    t.string   "primary_contact_name"
    t.string   "primary_contact_email"
    t.integer  "default_app_order"
    t.string   "sharing_preference"
    t.boolean  "caliper",                                      default: false
    t.text     "caliper_metric_profiles"
    t.text     "caliper_ims_global_certifications"
    t.string   "support_contact_name"
    t.string   "support_contact_email"
    t.string   "download_size"
    t.string   "supported_languages"
    t.boolean  "license_is_free"
    t.boolean  "license_is_paid"
    t.boolean  "license_is_recharge"
    t.boolean  "license_is_by_seat"
    t.boolean  "license_is_subscription"
    t.boolean  "license_is_ad_supported"
    t.boolean  "license_is_other"
    t.text     "license_text"
    t.boolean  "security_uses_https"
    t.boolean  "security_uses_additional_encryption"
    t.boolean  "security_requires_cookies"
    t.boolean  "security_requires_third_party_cookies"
    t.boolean  "student_data_stores_local_data"
    t.string   "security_session_lifetime"
    t.string   "security_cloud_vendor"
    t.string   "security_policy_url"
    t.string   "security_sla_url"
    t.text     "security_text"
    t.boolean  "student_data_requires_account"
    t.boolean  "student_data_has_opt_out_for_data_collection"
    t.boolean  "student_data_has_opt_in_for_data_collection"
    t.boolean  "student_data_shows_eula"
    t.boolean  "student_data_is_app_externally_hosted"
    t.boolean  "student_data_stores_pii"
    t.string   "wcag_url"
  end

  create_table "apps_categories", force: true do |t|
    t.integer "app_id"
    t.integer "category_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "in_filter_rulesets", force: true do |t|
    t.integer  "in_peer_id"
    t.text     "rules"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "in_payload_ignores", force: true do |t|
    t.string   "casa_originator_id"
    t.string   "casa_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_payload_ignores", ["casa_originator_id", "casa_id"], name: "index_in_payload_ignores_on_casa_originator_id_and_casa_id", using: :btree

  create_table "in_payloads", force: true do |t|
    t.string   "casa_originator_id"
    t.string   "casa_id"
    t.datetime "casa_timestamp"
    t.integer  "in_peer_id"
    t.integer  "app_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "original_content"
  end

  add_index "in_payloads", ["casa_originator_id", "casa_id", "casa_timestamp"], name: "uniq_casa_payload_id", unique: true, using: :btree
  add_index "in_payloads", ["casa_originator_id", "casa_id"], name: "index_in_payloads_on_casa_originator_id_and_casa_id", using: :btree
  add_index "in_payloads", ["casa_timestamp"], name: "index_in_payloads_on_casa_timestamp", using: :btree

  create_table "in_peers", force: true do |t|
    t.string   "name"
    t.text     "uri"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "casa_id"
  end

  create_table "lti_consumers", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth2_identities", force: true do |t|
    t.string   "provider",         null: false
    t.string   "provider_user_id", null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth2_identities", ["provider", "provider_user_id"], name: "provider_compound_key", unique: true, using: :btree
  add_index "oauth2_identities", ["user_id"], name: "index_oauth2_identities_on_user_id", using: :btree

  create_table "out_peers", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "netmask"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sites", force: true do |t|
    t.text     "heading"
    t.text     "css"
    t.text     "10485760"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mobile_appicon"
    t.string   "title"
    t.string   "mobile_title"
    t.text     "mobile_heading"
    t.text     "homepage_categories"
    t.text     "mobile_footer"
    t.text     "footer"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",         default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
