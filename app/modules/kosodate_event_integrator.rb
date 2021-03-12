require_relative "scrapers/calendar_scraper.rb"
require_relative "scrapers/oyako_hiroba_scraper.rb"

class KosodateEventIntegrator
  class << self
    def run(next_month: false)
      calendar = CalendarScraper.run(next_month: next_month)
      oyako_hiroba = OyakoHirobaScraper.run(next_month: next_month)

      events = calendar + oyako_hiroba
      KosodateEvent.bulk_insert(events)
    end
  end
end