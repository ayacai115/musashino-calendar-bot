require_relative '../../app/modules/reply_formatter.rb'

RSpec.describe ReplyFormatter do
  describe ".format" do
    example "今月の予定を返す" do
      create_list(:kosodate_event, 10, :current_month)
      reply = ReplyFormatter.format("今月")

      expect(reply[0][:type]).to eq("text")
      expect(reply[0][:text]).to be_an_instance_of(String)
    end

    example "来月の予定を返す" do
      create_list(:kosodate_event, 10, :next_month)
      reply = ReplyFormatter.format("来月")

      expect(reply[0][:type]).to eq("text")
      expect(reply[0][:text]).to be_an_instance_of(String)
    end

    example "反応できない文言には定型文を返す" do
      create_list(:kosodate_event, 10, :current_month)

      reply = ReplyFormatter.format("来週　桜堤")
      expect(reply[0][:type]).to eq("text")
      expect(reply[0][:text]).to eq ("まだ「今月」「来月」にしか反応できません。名前や場所検索は今後追加予定です！乞うご期待！")
    end
  end
end
