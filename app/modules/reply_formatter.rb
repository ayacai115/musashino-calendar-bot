require 'date'
require_relative "message_formatter.rb"

module ReplyFormatter
  NO_RESULTS_MESSAGE = "まだ「今月」「来月」にしか反応できません。名前や場所検索は今後追加予定です！乞うご期待！"

  class << self
    def format(text)
      today = Date.today

      events = if text == "今月"
                KosodateEvent.where(year: today.year, month: today.month)
              elsif text == "来月"
                KosodateEvent.where(year: today.year, month: today.next_month.month)
              else
                []
              end
              
      return no_result_found if events.empty?

      MessageFormatter.format(events)
    end

    private

    def no_result_found
      [{
        type: "text",
        text: NO_RESULTS_MESSAGE
      }]
    end
  end
end