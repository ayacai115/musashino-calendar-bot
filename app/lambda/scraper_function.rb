require 'pry'
require 'aws-sdk-dynamodb'
require_relative '../models/kosodate_events_scraper.rb'
require_relative '../models/dynamodb.rb'

def run(event:, context:)
  # 1. Scraperがインスタンスを返す
  year_month, events = KosodateEventsScraper.run
  event = events.first

  DynamoDB.put(event)

  # 2. DynamoDB delete -> insert

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用