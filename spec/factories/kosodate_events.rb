require_relative '../../app/models/kosodate_event.rb'

FactoryBot.define do
  factory :kosodate_event do
    date { Faker::Date.between(from: '2021-01-01', to: '2021-12-31') }
    name  { ["コミセン親子ひろば", "児童館・2月おはなしひろば"].sample }
    place { ["吉祥寺東", "西部コミュニティセンター"].sample }
    url { Faker::Internet.url }
    booking_required { [true, false].sample }

    initialize_with do
      new(
        date: date,
        name: name,
        place: place,
        url: url,
        booking_required: booking_required
      )
    end

    trait :oyako_hiroba do
      name { "コミセン親子ひろば" }
    end

    trait :childrens_center do
      name { "児童館・おはなしひろば" }
    end

    trait :current_month do
      today = Date.today
      beginning_of_month = today.strftime('%Y-%m-01')
      end_of_month = Date.new(today.year, today.month, -1)

      date { Faker::Date.between(from: beginning_of_month, to: end_of_month)}
    end

    trait :next_month do
      today = Date.today
      beginning_of_month = today.next_month.strftime('%Y-%m-01')
      end_of_month = Date.new(today.year, today.next_month.month, -1)

      date { Faker::Date.between(from: beginning_of_month, to: end_of_month)}
    end
  end
end