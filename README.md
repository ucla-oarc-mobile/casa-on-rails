# CASA On Rails

This application is a simple, easy-to-use app store that presents an storefront for finding and selecting apps, implements the [Community App Sharing Architecture protocol](http://imsglobal.github.io/casa-protocol), provides a mobile app dashboard using [Web Storage](http://dev.w3.org/html5/webstorage), and supports integration with learning management systems through [LTI Content-Item](http://www.imsglobal.org/lti/ltiv1p2pd/ltiCIMv1p0pd.html).

This application is **under development** and not intended for production use at this time.

## CASA

#### Protocol

The [Community App Sharing Architecture (CASA)](http://imsglobal.github.io/casa-protocol) provides a mechanism for discovering and sharing metadata about web resources such as websites, mobile apps and LTI tools. It models real-world decision-making through extensible attributes, filter and transform operations, flexible peering relationships, etc.

#### Integration

From the storefront, several different mechanisms are available:

1. Launch the application directly
2. Reply to an [LTI Consumer](http://www.imsglobal.org/lti) with the [ContentItemSelectionResponse message](http://www.imsglobal.org/lti/ltiv1p2pd/ltiCIMv1p0pd.html)
3. Add to [Web Storage](http://dev.w3.org/html5/webstorage) and present as a mobile dashboard

Additionally, CASA endpoints are exposed for:

* **Local outlets** via the [CASA Local module](http://imsglobal.github.io/casa-protocol/#Module/Local)
* **Adjacent peers** via the [CASA Publisher module](http://imsglobal.github.io/casa-protocol/#Module/Publisher)

#### Application

This application provides the following:

* A basic app store with apps and categories
* Browse categories and search by string for list of apps
* View details about and launch an app
* App submission by authenticated users
* Administer apps, categories, inbound peers and users
* Publish apps to outbound peers
* Receive apps from inbound peers with translation and squashing
* Relay apps received from inbound peers to outbound peers
* Provide apps to local outlets
* Provide apps via LTI ContentItemSelectionResponse message
* Provide apps via a mobile dashboard back by Web Storage

Additional features are planned:

* Filter and transform apps received from inbound peers and before sharing with outbound peers
* Mapping of inbound categories and tags to local categories
* Definition of authorization requirements for local outlets and outbound adjacent peers
* Journaling of changes to propagating apps

#### References

This application is a reduced and opinionated implementation of CASA. For a more overarching (but also more complex and challenging) implementation, the [CASA reference implementation](https://github.com/imsglobal/casa) may be useful. A series of [gems](https://github.com/imsglobal) were developed during the process of building this reference implementation, and they may be useful in some contexts as well.

## Configuration

The Basic steps below **must** be run prior to database migration and seeding, or your default site will not be created!

#### Basic

Set your CASA engine UUID and user contact information in your environment configuration file, such as:

```ruby
Rails.application.configure do

  # ..

  # Community App Sharing Architecture configuration
  config.casa = {
    :engine => {
      :uuid => 'dd8c99e2-fe5b-4911-a815-73c17b46d3fc'
    }
  }

  # Local configuration
  config.store = {
    :user_contact => { :name => 'John Doe', :email => 'admin@example.edu' }
  }

  # ..

end
```

#### Shibboleth Login via OAuth2 Bridge

This application supports Shibboleth login via the [Shibboleth-OAuth2 Bridge by Eric Bollens](https://github.com/ebollens/shib-oauth2-bridge).

Once the bridge is installed on your web server, add the following to your environment configuration:

```ruby
Rails.application.configure do

  # ..

  config.oauth2 = {
      :provider => {
          :shibboleth => {
              :enabled => true,
              :key => 'demo',
              :secret => 'secret',
              :properties => {
                  :site => 'http://auth.example.edu',
                  :authorize_url => '/oauth2/authorize',
                  :token_url => '/oauth2/access_token'
              },
              :routes => {
                  :get_user => '/oauth2/user'
              },
              :restrict_to => {
                  :eduPersonPrincipalName => [
                    # users by eduPersonPrincipalName that are allowed to submit apps
                  ],
                  :eduPersonScopedAffiliation => [
                    # eduPersonScopedAffiliations that are allowed to submit apps
                    'employee@ucla.edu'
                  ]
              }
          }
      }
  }

  config.login_route = [:session_oauth2_launch_url, :shibboleth]

  # ..

end
```

This configuration makes it possible for users with the `employee@ucla.edu` eduPersonAffiliation to log in and submit applications for review.

## Setup

#### System Dependencies

* Ruby 2.1+
* Node.js 0.10+
* Java 1.6+
* MySQL 5.0+, PostgreSQL 8.4+ and SQLite 3.6.16+ *
* ElasticSearch 1.0+

*\*To use a database besides MySQL, update `Gemfile` accordingly*

#### Manged Dependencies

For Ruby packages:

```
bundle
```

For Node packages:

```
npm install
```

#### Build Web Assets

To build web assets:

```
bundle exec blocks build
```

#### Configure Rails App

See:

* `config/database.yml` to set the database configuration
* `config/environments/*.rb` to set the `config.casa` and `config.store` variables

#### Setup Database

```
bundle exec bin/rake db:migrate
bundle exec bin/rake db:seed
```

## Usage

CASA on Rails is a standard Rails server. Once you ensure that the database and Elasticsearch are running, start it as you'd usually start a Rails server.

If you seeded the database, the default credentials are:
```
Username: admin
Password: password
```

### Docker Container

CASA on Rails now has a docker container to facilitate getting started developing or testing the project.  Visit the [docker hub page](https://hub.docker.com/r/stevenolen/casa-on-rails/) for more details.

## License

CASA On Rails is **open-source** and licensed under the AFFERO GENERAL PUBLIC LICENSE. The full text of the license may be found in the `LICENSE` file.
