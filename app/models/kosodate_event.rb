class KosodateEvent
  attr_reader :date, :name, :url, :booking_required

  class << self
    def insert(year_month, events)
    end
  end

  def initialize(date:, name:, url:, booking_required:)
    @date = date
    @name = name
    @url = url
    @booking_required = booking_required
  end
end