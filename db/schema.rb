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

ActiveRecord::Schema.define(version: 20180828221745) do

  create_table "app_authors", force: :cascade do |t|
    t.integer "app_id",  limit: 4
    t.string  "name",    limit: 255
    t.string  "email",   limit: 255
    t.string  "website", limit: 255
  end

  create_table "app_browser_features", force: :cascade do |t|
    t.integer "app_id",  limit: 4
    t.string  "feature", limit: 255
    t.string  "level",   limit: 255
  end

  add_index "app_browser_features", ["feature"], name: "index_app_browser_features_on_feature", using: :btree
  add_index "app_browser_features", ["level"], name: "index_app_browser_features_on_level", using: :btree

  create_table "app_competencies", force: :cascade do |t|
    t.integer  "app_id",     limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_features", force: :cascade do |t|
    t.integer  "app_id",       limit: 4
    t.string   "feature_name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_launch_methods", force: :cascade do |t|
    t.integer  "app_id",     limit: 4
    t.string   "method",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_lti_configs", force: :cascade do |t|
    t.integer  "app_id",                             limit: 4
    t.string   "lti_launch_url",                     limit: 255
    t.text     "lti_launch_params",                  limit: 65535
    t.string   "lti_registration_url",               limit: 255
    t.string   "lti_configuration_url",              limit: 255
    t.text     "lti_content_item_message",           limit: 65535
    t.string   "lti_lis_outcomes",                   limit: 255
    t.string   "lti_version",                        limit: 255
    t.string   "lti_ims_global_registration_number", limit: 255
    t.string   "lti_ims_global_conformance_date",    limit: 255
    t.string   "lti_ims_global_registration_link",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "lti_default"
    t.text     "lti_oauth_consumer_key",             limit: 65535
    t.text     "lti_oauth_consumer_secret",          limit: 65535
    t.integer  "lti_consumer_id",                    limit: 4
  end

  add_index "app_lti_configs", ["app_id", "lti_consumer_id"], name: "index_app_lti_configs_on_app_id_and_lti_consumer_id", unique: true, using: :btree

  create_table "app_media_requirements", force: :cascade do |t|
    t.integer "app_id",            limit: 4
    t.boolean "color"
    t.string  "max_aspect_ratio",  limit: 255
    t.string  "max_color",         limit: 255
    t.string  "max_device_height", limit: 255
    t.string  "max_device_width",  limit: 255
    t.string  "max_height",        limit: 255
    t.string  "max_resolution",    limit: 255
    t.string  "max_width",         limit: 255
    t.string  "min_aspect_ratio",  limit: 255
    t.string  "min_color",         limit: 255
    t.string  "min_device_height", limit: 255
    t.string  "min_device_width",  limit: 255
    t.string  "min_height",        limit: 255
    t.string  "min_resolution",    limit: 255
    t.string  "min_width",         limit: 255
  end

  create_table "app_organizations", force: :cascade do |t|
    t.integer "app_id",  limit: 4
    t.string  "name",    limit: 255
    t.string  "website", limit: 255
  end

  create_table "app_out_peer_permissions", force: :cascade do |t|
    t.integer  "app_id",      limit: 4
    t.integer  "out_peer_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_privacy_policies", force: :cascade do |t|
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

  create_table "app_ratings", force: :cascade do |t|
    t.integer  "app_id",     limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "score",      limit: 4
    t.text     "review",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_tags", force: :cascade do |t|
    t.integer  "app_id",     limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_wcag_guidelines", force: :cascade do |t|
    t.integer  "app_id",     limit: 4
    t.string   "guideline",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", force: :cascade do |t|
    t.string   "title",                                        limit: 255
    t.text     "uri",                                          limit: 65535
    t.text     "icon",                                         limit: 65535
    t.text     "description",                                  limit: 65535
    t.boolean  "enabled",                                                    default: false
    t.boolean  "share",                                                      default: true
    t.boolean  "propagate",                                                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "casa_in_payload",                              limit: 65535
    t.string   "casa_id",                                      limit: 255
    t.string   "casa_originator_id",                           limit: 255
    t.string   "short_description",                            limit: 255
    t.integer  "app_privacy_policy_id",                        limit: 4
    t.text     "privacy_url",                                  limit: 65535
    t.text     "accessibility_url",                            limit: 65535
    t.text     "vpat_url",                                     limit: 65535
    t.text     "acceptable",                                   limit: 65535
    t.text     "ios_app_id",                                   limit: 65535
    t.text     "ios_app_scheme",                               limit: 65535
    t.text     "ios_app_path",                                 limit: 65535
    t.text     "ios_app_affiliate_data",                       limit: 65535
    t.text     "android_app_package",                          limit: 65535
    t.text     "android_app_scheme",                           limit: 65535
    t.text     "android_app_action",                           limit: 65535
    t.text     "android_app_category",                         limit: 65535
    t.text     "android_app_component",                        limit: 65535
    t.boolean  "lti",                                                        default: false
    t.boolean  "restrict",                                                   default: false
    t.boolean  "mobile_support",                                             default: false
    t.boolean  "restrict_launch",                                            default: false
    t.integer  "created_by",                                   limit: 4
    t.boolean  "official",                                                   default: false
    t.string   "primary_contact_name",                         limit: 255
    t.string   "primary_contact_email",                        limit: 255
    t.integer  "default_app_order",                            limit: 4
    t.string   "sharing_preference",                           limit: 255
    t.boolean  "caliper",                                                    default: false
    t.text     "caliper_metric_profiles",                      limit: 65535
    t.text     "caliper_ims_global_certifications",            limit: 65535
    t.string   "support_contact_name",                         limit: 255
    t.string   "support_contact_email",                        limit: 255
    t.string   "download_size",                                limit: 255
    t.string   "supported_languages",                          limit: 255
    t.boolean  "license_is_free"
    t.boolean  "license_is_paid"
    t.boolean  "license_is_recharge"
    t.boolean  "license_is_by_seat"
    t.boolean  "license_is_subscription"
    t.boolean  "license_is_ad_supported"
    t.boolean  "license_is_other"
    t.text     "license_text",                                 limit: 65535
    t.boolean  "security_uses_https"
    t.boolean  "security_uses_additional_encryption"
    t.boolean  "security_requires_cookies"
    t.boolean  "security_requires_third_party_cookies"
    t.boolean  "student_data_stores_local_data"
    t.string   "security_session_lifetime",                    limit: 255
    t.string   "security_cloud_vendor",                        limit: 255
    t.string   "security_policy_url",                          limit: 255
    t.string   "security_sla_url",                             limit: 255
    t.text     "security_text",                                limit: 65535
    t.boolean  "student_data_requires_account"
    t.boolean  "student_data_has_opt_out_for_data_collection"
    t.boolean  "student_data_has_opt_in_for_data_collection"
    t.boolean  "student_data_shows_eula"
    t.boolean  "student_data_is_app_externally_hosted"
    t.boolean  "student_data_stores_pii"
    t.string   "wcag_url",                                     limit: 255
    t.integer  "overall_review_status",                        limit: 4
    t.integer  "privacy_review_status",                        limit: 4
    t.integer  "security_review_status",                       limit: 4
    t.integer  "accessibility_review_status",                  limit: 4
    t.string   "tool_review_url",                              limit: 255
    t.text     "privacy_text",                                 limit: 65535
  end

  add_index "apps", ["propagate"], name: "index_apps_on_propagate", using: :btree
  add_index "apps", ["share"], name: "index_apps_on_share", using: :btree
  add_index "apps", ["title"], name: "index_apps_on_title", using: :btree

  create_table "apps_categories", force: :cascade do |t|
    t.integer "app_id",      limit: 4
    t.integer "category_id", limit: 4
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "in_filter_rulesets", force: :cascade do |t|
    t.integer  "in_peer_id", limit: 4
    t.text     "rules",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "in_payload_ignores", force: :cascade do |t|
    t.string   "casa_originator_id", limit: 255
    t.string   "casa_id",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "in_payload_ignores", ["casa_originator_id", "casa_id"], name: "index_in_payload_ignores_on_casa_originator_id_and_casa_id", using: :btree

  create_table "in_payloads", force: :cascade do |t|
    t.string   "casa_originator_id", limit: 255
    t.string   "casa_id",            limit: 255
    t.datetime "casa_timestamp"
    t.integer  "in_peer_id",         limit: 4
    t.integer  "app_id",             limit: 4
    t.text     "content",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.text     "original_content",   limit: 65535
  end

  add_index "in_payloads", ["casa_originator_id", "casa_id", "casa_timestamp"], name: "uniq_casa_payload_id", unique: true, using: :btree
  add_index "in_payloads", ["casa_originator_id", "casa_id"], name: "index_in_payloads_on_casa_originator_id_and_casa_id", using: :btree
  add_index "in_payloads", ["casa_timestamp"], name: "index_in_payloads_on_casa_timestamp", using: :btree

  create_table "in_peers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "uri",        limit: 65535
    t.string   "secret",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "casa_id",    limit: 255
  end

  add_index "in_peers", ["name"], name: "index_in_peers_on_name", using: :btree

  create_table "lti_consumers", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "key",                 limit: 255
    t.string   "secret",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "event_store_url",     limit: 65535
    t.string   "event_store_api_key", limit: 255
    t.string   "sso_type",            limit: 255
    t.string   "sso_idp_url",         limit: 255
  end

  add_index "lti_consumers", ["key"], name: "index_lti_consumers_on_key", unique: true, using: :btree

  create_table "oauth2_identities", force: :cascade do |t|
    t.string   "provider",         limit: 255, null: false
    t.string   "provider_user_id", limit: 255, null: false
    t.integer  "user_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth2_identities", ["provider", "provider_user_id"], name: "provider_compound_key", unique: true, using: :btree
  add_index "oauth2_identities", ["user_id"], name: "index_oauth2_identities_on_user_id", using: :btree

  create_table "out_peers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "netmask",    limit: 255
    t.string   "secret",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "out_peers", ["name"], name: "index_out_peers_on_name", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "sites", force: :cascade do |t|
    t.text     "heading",             limit: 65535
    t.text     "css",                 limit: 65535
    t.text     "10485760",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mobile_appicon",      limit: 65535
    t.string   "title",               limit: 255
    t.string   "mobile_title",        limit: 255
    t.text     "mobile_heading",      limit: 65535
    t.text     "homepage_categories", limit: 65535
    t.text     "mobile_footer",       limit: 65535
    t.text     "footer",              limit: 65535
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",      limit: 255
    t.string   "password_hash", limit: 255
    t.string   "password_salt", limit: 255
    t.boolean  "admin",                     default: false
    t.string   "first_name",    limit: 255
    t.string   "last_name",     limit: 255
    t.string   "email",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
