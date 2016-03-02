require 'time'
require 'json'
require 'rufus-scheduler'
require 'casa/peer/payload_retriever'

Rufus::Scheduler.singleton.every '30m' do
  PayloadRetriever.get_payloads
end
