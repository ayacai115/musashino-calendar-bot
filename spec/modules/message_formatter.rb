require_relative '../../app/modules/message_formatter.rb'

RSpec.describe MessageFormatter do
  describe ".format" do
    example "イベント一覧を渡すと、日付区切りのメッセージを作成する" do
      events = create_list(:kosodate_event, 5, date: Date.today)
      events += create_list(:kosodate_event, 5, date: (Date.today + 4))
      events += create_list(:kosodate_event, 5, date: (Date.today + 9))
      events += create_list(:kosodate_event, 5, date: (Date.today + 14))

      MessageFormatter.format(events)
    end
  end
end
