require 'json'

class MobileController < ApplicationController

  skip_before_action :verify_authenticity_token

  def initialize
    @local_storage_key = 'casa-apps'
    @default_apps = [
        { title: 'Directory', uri: 'http://m.ucla.edu/directory/', icon: 'http://apps.m.ucla.edu/native/ios/images/directory/72x72.png'},
        { title: 'Map', uri: 'http://maps.ucla.edu/m/campus/', icon: 'http://apps.m.ucla.edu/native/ios/images/campus-map/72x72.png' },
        { title: 'Happenings', uri: 'http://m.happenings.ucla.edu/?no_server_init', icon: 'http://apps.m.ucla.edu/native/ios/images/events/72x72.png' },
        { title: 'Dining', uri: 'http://m.dining.ucla.edu/', icon: 'http://apps.m.ucla.edu/native/ios/images/dining/72x72.png' },
        { title: 'Bruin Mobile', uri: 'http://m.ucla.edu/index.php?s=bruin_mobile', icon: 'http://apps.m.ucla.edu/native/ios/images/bear/72x72.png' },
        { title: 'Library', uri: 'http://m.library.ucla.edu', icon: 'http://apps.m.ucla.edu/native/ios/images/library/72x72.png' }
    ]
  end

  def index
    render layout: false
  end

  def launch
    launch_provider.set :mobile
    redirect_to '/'
  end

  def return
    @app = App.find params[:id]
    @location = mobile_url
    launch_provider.destroy!
    render layout: 'application'
  end

end