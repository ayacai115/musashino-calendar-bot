require_relative '../../../app/modules/scrapers/calendar_scraper.rb'

RSpec.describe CalendarScraper do
  describe ".run" do
    example "今月の子育てイベント情報を取得する" do
      result = CalendarScraper.run
      expect(result).to be_a_kind_of(Seahorse::Client::Response)
    end
  end
end

