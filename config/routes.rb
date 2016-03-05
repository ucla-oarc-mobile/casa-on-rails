Rails.application.routes.draw do

  root 'apps#index'

  get 'apps/search', to: 'apps#search'
  resources :apps, :only => [:index, :show] do
    member do
      resources :ratings, module: 'apps', as: 'app_ratings', param: :rating_id
    end
  end

  resources :categories, :only => [:index, :show]

  get 'session', to: 'session#create'
  post 'session', to: 'session#store'
  delete 'session', to: 'session#destroy'

  namespace :session do
    get '/oauth2/:id', to: 'oauth2#return', as: :oauth2_return, constraints: lambda { |request| request.query_parameters.include? 'code' }
    get '/oauth2/:id', to: 'oauth2#launch', as: :oauth2_launch
  end

  namespace :manage do

    resources :apps

  end

  namespace :admin do

    resources :apps
    resources :categories
    resources :in_payloads do
        get 'to_app', to: 'in_payloads#to_app'
    end
    resources :in_filter_rulesets
    resources :in_peers
    resources :out_peers
    resources :lti_consumers
    resources :users
    resources :sites

  end

  namespace :casa do

    get 'out/payloads', to: 'out#all'
    get 'out/payloads(/:originator_id)/:id', to: 'out#one'

    get 'local/payloads', to: 'local#all'
    get 'local/payloads/_elasticsearch', to: 'local#query'
    get 'local/payloads(/:originator_id)/:id', to: 'local#one'

  end

  post 'lti/launch', to: 'lti#launch'
  # Uncomment to allow an OAuth-ed LTI Launch via query parameters - handy for testing
  # get 'lti/launch', to: 'lti#launch'
  get 'lti/content_item/(:id)', to: 'lti#content_item'

  namespace :mobile do

    get 'cordova/launch', to: 'cordova#launch', as: 'cordova_launch'
    get 'cordova/exec/(:id)', to: 'cordova#exec', as: 'cordova_exec'

    get 'web_view_javascript_bridge/launch', to: 'web_view_javascript_bridge#launch', as: 'web_view_javascript_bridge_launch'
    get 'web_view_javascript_bridge/send/(:id)', to: 'web_view_javascript_bridge#_send', as: 'web_view_javascript_bridge_send'

  end

  get 'mobile', to: 'mobile#index'
  get 'mobile/launch', to: 'mobile#launch'
  get 'mobile/return/(:id)', to: 'mobile#return'
  get 'mobile/abort', to: 'mobile#abort'

  # get 'status.json' is used by the rapporteur gem.

end
