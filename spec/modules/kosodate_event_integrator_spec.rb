require_relative '../../app/modules/kosodate_event_integrator.rb'
require_relative '../../app/modules/scrapers/calendar_scraper.rb'
require_relative '../../app/modules/scrapers/oyako_hiroba_scraper.rb'

RSpec.describe KosodateEventIntegrator do
  describe ".run" do
    example "親子ひろばがあれば、追加する" do
      calendar_event = build(:kosodate_event, :childrens_center, date: Date.today)
      oyako_hiroba_event = build(:kosodate_event, :oyako_hiroba, date: Date.today)

      allow(CalendarScraper).to receive(:run).and_return([calendar_event])
      allow(OyakoHirobaScraper).to receive(:run).and_return([oyako_hiroba_event])

      KosodateEventIntegrator.run 

      events = KosodateEvent.all
      expect(events.count).to eq(2)
    end

    example "親子ひろばが無い場合は、カレンダーのみを登録" do
      calendar_event = build(:kosodate_event, date: Date.today, name: "児童館・3月トランポリンの日")

      allow(CalendarScraper).to receive(:run).and_return([calendar_event])
      allow(OyakoHirobaScraper).to receive(:run).and_return([])

      KosodateEventIntegrator.run

      events = KosodateEvent.all
      expect(events.count).to eq(1)
    end
  end
end

