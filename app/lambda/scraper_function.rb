require 'pry'
require 'aws-sdk-dynamodb'
require_relative '../models/kosodate_events_scraper.rb'

def run(event:, context:)
  # 1. Scraperがインスタンスを返す
  year_month, events = KosodateEventsScraper.run
  event = events.first

  Aws.config.update(
    endpoint: 'http://localhost:8000', # ローカル専用
    region: 'ap-northeast-1'
    )

  client = Aws::DynamoDB::Client.new

  item = {
    year_month: "#{event.date.year}-#{event.date.month}",
    date_and_id: "#{event.date.day}-1",
    name: event.name,
    url: event.url,
    booking_required: event.booking_required
  }

  table_name = 'musashino-kosodate-events-local'

  table_item = {
    table_name: table_name,
    item: item
  }

  client.put_item(table_item)

  # 2. DynamoDB delete -> insert

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用