class BroadcastFormatter
  DAYS_OF_THE_WEEK = %w(日 月 火 水 木 金 土)
  DEVIDING_LINE = "\n--------------------------------------\n\n"
  BOOKING_REQUIRED = '【事前申込必要】'

  class << self
    def format(schedule)
      schedule = schedule.map do |date, events|

        events.map! do |event|
          "\n#{event['name']} #{BOOKING_REQUIRED if event['booking_required']} \n#{event['url']}\n" 
        end
        
        date = Date.parse(date)
        day_of_the_week = DAYS_OF_THE_WEEK[date.strftime('%w').to_i]
        display_date = date.strftime('%-m月%-d日') + '(' + day_of_the_week + ')' # 例 2月1日(月)

        [display_date, events].flatten!.join('')
      end

      formatted_message(schedule)
    end
    
    private

    def formatted_message(schedule)
      [{
        type: 'text',
        text: schedule[0..9].join(DEVIDING_LINE)
      },{
        type: 'text',
        text: schedule[10..19].join(DEVIDING_LINE)
      },{
        type: 'text',
        text: schedule[20..30].join(DEVIDING_LINE)
      }]
    end
  end
end