class KosodateEvent
  attr_reader :date, :title, :url, :booking_required

  def initialize(date:, title:, url:, booking_required:)
    @date = date
    @title = title
    @url = url
    @booking_required = booking_required
  end
end