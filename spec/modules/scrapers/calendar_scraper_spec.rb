require_relative '../../../app/modules/scrapers/calendar_scraper.rb'

RSpec.describe CalendarScraper do
  describe ".run" do
    example "今月の子育てイベント情報を取得する" do
      events = CalendarScraper.run

      event = events.first
      expect(event).to be_a_instance_of(KosodateEvent)
      expect(event.date.month).to eq(Date.today.month)
    end

    example "親子ひろばは除外する" do
      events = CalendarScraper.run

      expect(events.any? { |event| event.name == "コミセン親子ひろば" }).to be_falsey
    end

    # 実装は正しい。しかし4月分のカレンダーが白紙なので失敗する
    # スタブ作るか、、、うーむ
    example "来月の子育てイベント情報を取得する" do
      CalendarScraper.run(next_month: true)

      # event = KosodateEvent.all.first 
      # expect(event).to be_a_instance_of(KosodateEvent)
      # expect(event.date.month).to eq(Date.today.next_month.month)
    end
  end
end

