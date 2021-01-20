require 'pry'
require_relative '../models/kosodate_events_scraper.rb'

def run(event:, context:)
  # 1. Scraperがインスタンスを返す
  events = KosodateEventsScraper.run

  # 2. DynamoDB delete -> insert

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用