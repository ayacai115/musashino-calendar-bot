require_relative '../../app/models/kosodate_event.rb'

RSpec.describe KosodateEvent do
  describe "#initialize" do
    example "インスタンスを作成" do
      events = build(:kosodate_event)
    end

    example "場所は無しでも作成できる" do
    end
  end

  describe "#save!" do
    example "保存ができる" do
      event = build(:kosodate_event)
      event.save!
    end
  end

  describe ".where" do
    example "年月を指定して取得する" do
      4.times { create(:kosodate_event, date: Faker::Date.between(from: '2021-01-01', to: '2021-01-31')) }
      create(:kosodate_event, date: Faker::Date.between(from: '2021-02-01', to: '2021-02-28'))

      events = KosodateEvent.where(year: '2021', month: '02')
      expect(events.count).to be(1)
    end

    example "日付を指定して取得する" do
      4.times { create(:kosodate_event, date: Faker::Date.between(from: '2021-01-01', to: '2021-01-15')) }
      create(:kosodate_event, date: Date.new(2021, 1, 20))

      events = KosodateEvent.where(year: '2021', month: '01', date: [20])
      expect(events.count).to be(1)
    end

    example "名前を指定して取得する" do
    end
  end

  describe ".all" do
    example "全件取得する" do
      create_list(:kosodate_event, 10)
      
      events = KosodateEvent.all
      expect(events.count).to be(10)

      event = events.first
      expect(event.date).to be_an_instance_of(Date)
      expect(event.name).to be_an_instance_of(String)
      expect(event.place).to be_an_instance_of(String)
      expect(event.url).to be_an_instance_of(String)
      expect(event.booking_required).to be(true || false)
    end
  end
end
