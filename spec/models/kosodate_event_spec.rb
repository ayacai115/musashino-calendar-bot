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
end
