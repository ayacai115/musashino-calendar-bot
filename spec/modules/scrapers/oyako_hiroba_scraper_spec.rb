require_relative '../../../app/modules/scrapers/oyako_hiroba_scraper.rb'

RSpec.describe OyakoHirobaScraper do
  describe ".run" do
    example "今月の親子ひろば予定を取得する" do
      events = OyakoHirobaScraper.run

      event = events.first
      expect(event).to be_instance_of(KosodateEvent)
      expect(event.date.month).to eq(Date.today.month)
    end

    example "来月の親子ひろば予定を取得する" do
      events = OyakoHirobaScraper(next_month: true)

      event = events.first
      expect(event).to be_instance_of(KosodateEvent)
      expect(event.date.month).to eq(Date.today.next_month.month)
    end
  end
end

