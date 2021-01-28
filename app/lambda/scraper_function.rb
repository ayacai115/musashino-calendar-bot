require 'aws-sdk-dynamodb'
require_relative '../modules/kosodate_events_scraper.rb'

def run(event:, context:)
  KosodateEventsScraper.run
end

run(event: nil, context: nil) # テスト用