require_relative '../../app/models/kosodate_event.rb'

RSpec.describe KosodateEvent do
  describe "#initialize" do
    example "インスタンスを作成" do
      events = build(:kosodate_event)
    end

    example "場所は無しでも作成できる" do
    end
  end

  describe "#save" do
    example "保存ができる" do
      event = build(:kosodate_event)
      event.save
    end
  end

  describe ".where" do
    example "年月を指定して取得する" do
      4.times { create(:kosodate_event, date: Faker::Date.between(from: '2021-01-01', to: '2021-01-31')) }
      create(:kosodate_event, date: Faker::Date.between(from: '2021-02-01', to: '2021-02-28'))
      events = KosodateEvent.where(year: '2021', month: '02')

      expect(events.count).to be(1)
    end

    example "名前を指定して取得する" do
    end
  end
end
