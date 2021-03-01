require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = "musashino-kosodate-events-#{ENV['STAGE'] || 'local'}".freeze
  
  attr_accessor :date, :name, :place, :url, :booking_required

  def initialize(date:, name:, place: nil, url:, booking_required:)
    @date = date
    @name = name
    @place = place
    @url = url
    @booking_required = booking_required
  end

  def save!
    item = {
      date: formatted_date,
      name: name,
      place: place,
      url: url,
      booking_required: booking_required
    }

    DynamoDB.put(TABLE_NAME, item)
  end

  def formatted_date
    date.strftime('%Y-%m-%d')
  end

  class << self
    def where(year:, month:, dates: nil, name: nil)
      items = DynamoDB.scan(TABLE_NAME).items
      return if items.nil?

      items = parse(items)
      
      items = filter_by_year_month(items, year, month)
      items = filter_by_date(items, dates) if dates
      items = filter_by_name(items, name) if name

      items
    end

    def all
      items = DynamoDB.scan(TABLE_NAME).items
      parse(items)
    end

    def bulk_insert(events)
      events.map! do |event|
        {
          date: event.formatted_date,
          name: event.name,
          place: event.place,
          url: event.url,
          booking_required: event.booking_required
        }
      end

      DynamoDB.batch_write_item(TABLE_NAME, events)
    end

    private

    def filter_by_year_month(items, year, month)
      items.filter { |item| item.date.year == year && item.date.month == month }
    end

    def filter_by_date(items, dates)
      items.filter { |item| dates.include?(item.date.day) }
    end

    def filter_by_name(items, name)
      items.filter { |item| item.name.include?(name) }
    end
    
    # KosodateEventインスタンスに変換する
    def parse(items)
      items.map do |item|
        new(date: Date.parse(item["date"]),
            name: item["name"],
            place: item["place"],
            url: item["url"],
            booking_required: item["booking_required"])
      end
    end
  end
end
