require_relative '../../app/models/kosodate_event.rb'

RSpec.describe KosodateEvent do
  describe "#initialize" do
    example "保存できる" do
      events = build_list(:kosodate_event, 5)
    end
  end
end
