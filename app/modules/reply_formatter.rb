require 'date'
require_relative "message_formatter.rb"
require_relative "../models/kosodate_event.rb"

module ReplyFormatter

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
        text: "まだ「今月」「来月」にしか反応できません$\n名前や場所での検索を今後追加予定です！ご期待ください$$",
        emojis: [
          {
            index: 20,
            productId: "5ac1bfd5040ab15980c9b435",
            emojiId: "179"
          },
          {
            index: 48,
            productId: "5ac1bfd5040ab15980c9b435",
            emojiId: "156"
          },
          {
            index: 49,
            productId: "5ac1de17040ab15980c9b438",
            emojiId: "018 "
          }
        ]
      }]
    end
  end
end