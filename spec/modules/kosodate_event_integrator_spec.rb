require_relative '../../app/modules/kosodate_event_integrator.rb'
require_relative '../../app/modules/scrapers/calendar_scraper.rb'
require_relative '../../app/modules/scrapers/oyako_hiroba_scraper.rb'

RSpec.describe KosodateEventIntegrator do
  describe ".run" do
    example "イベント情報を統合する" do
      calendar_events = build_list(:kosodate_event, 5, name: "ちびっこランド")
      allow(CalendarScraper).to receive(:run).and_return(calendar_events)

      oyako_hiroba_events = build_list(:kosodate_event, 5, name: "コミセン親子ひろば")
      allow(OyakoHirobaScraper).to receive(:run).and_return(oyako_hiroba_events)

      KosodateEventIntegrator.run
      expect(KosodateEvent.all.count).to eq(10)
    end
  end
end

