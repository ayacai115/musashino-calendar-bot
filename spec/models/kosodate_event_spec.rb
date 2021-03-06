require_relative '../../app/models/kosodate_event.rb'

RSpec.describe KosodateEvent do
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

      events = KosodateEvent.where(year: 2021, month: 2)
      expect(events.count).to eq(1)
    end

    example "日付を指定して取得する" do
      4.times { create(:kosodate_event, date: Faker::Date.between(from: '2021-01-01', to: '2021-01-15')) }
      create(:kosodate_event, date: Date.new(2021, 1, 20))

      events = KosodateEvent.where(year: 2021, month: 1, dates: [20, 21])
      expect(events.count).to eq(1)
    end

    example "名前を指定して取得する（部分一致）" do
      date = Faker::Date.between(from: '2021-01-01', to: '2021-01-31')
      4.times { create(:kosodate_event, name: 'コミセン親子ひろば', date: date) }
      create(:kosodate_event, name: 'ふたご・みつごのつどい', date: date)

      events = KosodateEvent.where(year: 2021, month: 1, name: 'ふたご')
      expect(events.count).to eq(1)
    end

    example "名前を指定して取得する（完全一致）" do
      date = Faker::Date.between(from: '2021-01-01', to: '2021-01-31')
      4.times { create(:kosodate_event, name: 'コミセン親子ひろば', date: date) }
      create(:kosodate_event, name: 'ふたご・みつごのつどい', date: date)

      events = KosodateEvent.where(year: 2021, month: 1, name: 'ふたご・みつごのつどい')
      expect(events.count).to eq(1)
    end
  end

  describe ".all" do
    example "全件取得する" do
      date = Date.today
      create(:kosodate_event, date: date)
      create(:kosodate_event, date: date + 1)
      create(:kosodate_event, date: date + 2)
      create(:kosodate_event, date: date + 3)
      create(:kosodate_event, date: date + 4)
      
      events = KosodateEvent.all
      expect(events.count).to eq(5)

      event = events.first
      expect(event.date).to be_an_instance_of(Date)
      expect(event.name).to be_an_instance_of(String)
      expect(event.place).to be_an_instance_of(String)
      expect(event.url).to be_an_instance_of(String)
      expect([true, false]).to include(event.booking_required)
    end
  end

  describe ".bulk_insert" do
    example "一括で保存できる" do
      events = build_list(:kosodate_event, 10)
      KosodateEvent.bulk_insert(events)

      expect(KosodateEvent.all.count).to eq(10)
    end
  end
end
