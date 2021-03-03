require_relative '../../app/modules/kosodate_event_integrator.rb'
require_relative '../../app/modules/scrapers/calendar_scraper.rb'
require_relative '../../app/modules/scrapers/oyako_hiroba_scraper.rb'

RSpec.describe KosodateEventIntegrator do
  describe ".run" do
    example "親子ひろばがすでにカレンダーにある場合は、場所だけ追加する" do
      name = "コミセン親子ひろば"
      place = "吉祥寺東"
      calendar_event = build(:kosodate_event, date: Date.today, name: name)
      oyako_hiroba_event = build(:kosodate_event, date: Date.today, name: name, place: place)

      allow(CalendarScraper).to receive(:run).and_return([calendar_event])
      allow(OyakoHirobaScraper).to receive(:run).and_return([oyako_hiroba_event])

      KosodateEventIntegrator.run 
      
      events = KosodateEvent.all
      expect(events.count).to eq(1)

      event = events.first
      expect(event.name).to eq(name)
      expect(event.place).to eq(place)
    end

    example "親子ひろばが無い場合は、イベントそのものを追加する" do
    end
  end
end

