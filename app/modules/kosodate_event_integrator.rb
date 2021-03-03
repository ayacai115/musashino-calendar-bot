class KosodateEventIntegrator
  class << self
    def run
      events = CalendarScraper.run + OyakoHirobaScraper.run

      # 重複したら場所だけ追加

      KosodateEvent.bulk_insert(events)
    end
  end
end