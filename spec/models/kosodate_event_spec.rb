require_relative '../../app/models/kosodate_event.rb'

RSpec.describe KosodateEvent do
  describe "#initialize" do
    it "initializes" do
      date = Date.new(2021, 2, 1)
      name = '親子ひろば'
      place = '西部コミセン'
      url = 'example.com'
      booking_required = true

      event = KosodateEvent.new(
        date: date,
        name: name,
        place: place,
        url: url,
        booking_required: booking_required
      )

      expect(event.date).to eq(date)
      expect(event.name).to eq(name)
      expect(event.place).to eq(place)
      expect(event.url).to eq(url)
      expect(event.booking_required).to eq(booking_required)
    end
  end
end
