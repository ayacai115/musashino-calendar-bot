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

    example "コミセン親子ひろばは、場所名も表示する" do
      event = create(:kosodate_event, :oyako_hiroba)

      message = MessageFormatter.format([event])
      expect(message[0][:text]).to include(event.place)
    end

    example "コミセン親子ひろばでなければ、場所名は表示しない" do
      event = create(:kosodate_event, :childrens_center)

      message = MessageFormatter.format([event])
      expect(message[0][:text]).not_to include(event.place)
    end
  end
end
