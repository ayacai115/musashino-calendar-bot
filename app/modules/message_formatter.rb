module MessageFormatter
  DAYS_OF_THE_WEEK = %w(日 月 火 水 木 金 土)
  DEVIDING_LINE = "\n--------------------------------------\n\n"
  BOOKING_REQUIRED = '【事前申込必要】'

  class << self
    def format(events)
      schedule = events.group_by{ |event| event.date }.sort

      formatted_schedule = schedule.map do |date, event_items|
        event_items.map! { |event| build_event_detail(event) }
        
        day_of_the_week = DAYS_OF_THE_WEEK[date.strftime('%w').to_i]
        display_date = date.strftime('%-m月%-d日') + '(' + day_of_the_week + ')' # 例 2月1日(月)

        [display_date, event_items].flatten!.join('')
      end

      formatted_message(formatted_schedule)
    end

    private

    def build_event_detail(event)
      if event.oyako_hiroba?
        "\n#{event.name}@#{event.place} #{BOOKING_REQUIRED if event.booking_required} \n#{event.url}\n" 
      else
        "\n#{event.name} #{BOOKING_REQUIRED if event.booking_required} \n#{event.url}\n" 
      end
    end

    def formatted_message(schedule)
      message = []
      schedule.each_slice(10) do |dates|
        message << {
          type: 'text',
          text: dates.join(DEVIDING_LINE)
        }
      end

      message
    end
  end
end