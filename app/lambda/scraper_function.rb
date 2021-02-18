require 'aws-sdk-dynamodb'
require_relative '../modules/scrapers/calendar_scraper.rb'

def run(event:, context:)
  CalendarScraper.run
end
