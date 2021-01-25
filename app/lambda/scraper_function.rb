require 'pry'
require 'aws-sdk-dynamodb'
require_relative '../modules/kosodate_events_scraper.rb'

def run(event:, context:)
  year_month, events = KosodateEventsScraper.run

  event = events.first
  KosodateEvent.create(event)

  # 2. DynamoDB delete -> insert

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用