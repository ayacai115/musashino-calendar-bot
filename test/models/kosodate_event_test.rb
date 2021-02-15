require_relative '../test_helper.rb'
require_relative '../../app/models/kosodate_event.rb'

class KosodateEventTest < Minitest::Test
  def test_initialize
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

    assert_equal date, event.date
    assert_equal name, event.name
    assert_equal place, event.place
    assert_equal url, event.url
    assert_equal booking_required, event.booking_required
  end
end