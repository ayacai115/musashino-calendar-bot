require_relative '../models/kosodate_events_scraper.rb'

def run(event:, context:)
  # 1. Scraperがインスタンスを返す
  # 2. DYnamoDBに保存する
  table_items = KosodateEventsScraper.run

  # TODO: DynamoDBにdelete -> insert

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用