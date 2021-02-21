require_relative '../../app/models/kosodate_event.rb'

FactoryBot.define do
  factory :kosodate_event do
    date { Date.new(2021, 2, 1) }
    name  { "親子ひろば" }
    place { "吉祥寺東" }
    url { "example.com" }
    booking_required { true }

    initialize_with do
      new(
        date: date,
        name: name,
        place: place,
        url: url,
        booking_required: booking_required
      )
    end
  end
end