require_relative '../test_helper.rb'
require_relative '../../app/models/kosodate_event.rb'

class KosodateEventTest < Minitest::Test
  def test_sample
    assert KosodateEvent
  end
end