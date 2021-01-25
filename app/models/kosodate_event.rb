require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = 'musashino-kosodate-events-local'.freeze
  attr_reader :date, :same_date_index, :name, :url, :booking_required

  class << self
    def create(event)
      item = {
        year_month: "#{event.date.year}-#{event.date.month}",
        date_and_id: "#{event.date.day}-#{event.same_date_index}",
        name: event.name,
        url: event.url,
        booking_required: event.booking_required
      }

      DynamoDB.put(TABLE_NAME, item)
    end
  end

  def initialize(date:, same_date_index:, name:, url:, booking_required:)
    @date = date
    @same_date_index = same_date_index
    @name = name
    @url = url
    @booking_required = booking_required
  end
end