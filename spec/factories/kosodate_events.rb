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
  end
end