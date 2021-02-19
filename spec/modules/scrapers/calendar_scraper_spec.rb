require_relative '../../../app/modules/scrapers/calendar_scraper.rb'

RSpec.describe CalendarScraper do
  describe ".run" do
    # DynamoDBをCI環境で使えるようにするまではコメントアウト
    example "今月の子育てイベント情報を取得する" do
      puts "ENV: "{ENV['STAGE']}"
      result = CalendarScraper.run
      expect(result).to be_a_kind_of(Seahorse::Client::Response)
    end

    example "来月の子育てイベント情報を取得する" do
      # result = CalendarScraper.run(next_month: true)
    end
  end
end

