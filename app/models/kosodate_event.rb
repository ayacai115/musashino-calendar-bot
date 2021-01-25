require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = 'musashino-kosodate-events-local'.freeze
  attr_reader :date, :name, :url, :booking_required

  class << self
    def create(event)
      item = {
        year_month: "#{event.date.year}-#{event.date.month}",
        date_and_id: "#{event.date.day}-2",
        name: event.name,
        url: event.url,
        booking_required: event.booking_required
      }

      DynamoDB.put(TABLE_NAME, item)
    end
  end

  def initialize(date:, name:, url:, booking_required:)
    @date = date
    @name = name
    @url = url
    @booking_required = booking_required
  end
end