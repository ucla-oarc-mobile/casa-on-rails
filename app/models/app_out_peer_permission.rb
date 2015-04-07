class AppOutPeerPermission < ActiveRecord::Base

  belongs_to :app
  belongs_to :out_peer

end
