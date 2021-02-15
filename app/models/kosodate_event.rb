require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = "musashino-kosodate-events-#{ENV['STAGE'] || 'local'}".freeze
  
  attr_reader :date
  attr_reader :name
  attr_reader :place 
  attr_reader :url 
  attr_reader :booking_required

  class << self
    def bulk_save(events) # 1ヶ月単位
      events_by_date = events.group_by { |event| event.date.strftime("%Y-%m-%d") }

      # KosodateEventオブジェクトをハッシュに変換
      data = events_by_date.map do |date, events_group|
        event_group = events_group.map do|event|
          {
            name: event.name,
            url: event.url,
            booking_required: event.booking_required
          }
        end
        [date, event_group]
      end.to_h

      item = {
        year_month: events.first.date.strftime("%Y-%m"),
        data: data.to_json,
        created_at: DateTime.now.new_offset('+9').strftime('%Y-%m-%d %H:%M')
      }

      DynamoDB.put(TABLE_NAME, item)
    end

    # year: yyyy, month: mm
    def where(year: nil, month: nil)
      key = {
        year_month: [year, month].join('-')
      }

      result = DynamoDB.get(TABLE_NAME, key)
      events_by_date = JSON.parse(result.item['data'])

      events_by_date.map do |date, events|
        events.map do |event|
          self.new(
            date: date,
            name: event["name"],
            place: event["place"],
            url: event["url"],
            booking_required: event["booking_required"]
          )
        end
      end.flatten!
    end
  end

  def initialize(date:, name:, place: nil, url:, booking_required:)
    @date = date
    @name = name
    @place = place
    @url = url
    @booking_required = booking_required
  end
end