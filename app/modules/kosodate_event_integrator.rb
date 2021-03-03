require_relative "scrapers/calendar_scraper.rb"
require_relative "scrapers/oyako_hiroba_scraper.rb"

class KosodateEventIntegrator
  class << self
    def run(next_month: false)
      calendar = CalendarScraper.run(next_month: next_month)
      oyako_hiroba = OyakoHirobaScraper.run(next_month: next_month)

      events = if calendar_includes_oyako_hiroba?(calendar)
                  add_place(calendar, oyako_hiroba)
                else
                  calendar + oyako_hiroba
                end

      KosodateEvent.bulk_insert(events)
    end

    # 親子ひろばのスケジュールは一括で反映されるため、1件あれば全件あるとみなす
    def calendar_includes_oyako_hiroba?(events)
      events.any? { |event| event.name == "コミセン親子ひろば"}
    end

    def add_place(calendar_events, oyako_hiroba_events)
      calendar_events.each do |event|
        next if event.name != "コミセン親子ひろば"

        same_event = oyako_hiroba_events.find { |oyako_event| event.date == oyako_event.date }
        event.place = same_event.place
      end

      calendar_events
    end
  end
end