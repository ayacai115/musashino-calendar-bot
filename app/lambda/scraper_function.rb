require 'aws-sdk-dynamodb'
require_relative '../modules/scrapers/current_month_event_scraper.rb'

def run(event:, context:)
  CurrentMonthEventScraper.run
end

run(event: nil, context: nil) # テスト用