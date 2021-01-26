require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = 'musashino-kosodate-events-local'.freeze
  
  attr_reader :year_month # 2021-01
  attr_reader :date # 01
  attr_reader :name
  attr_reader :url 
  attr_reader :booking_required

  class << self
    def save(year_month, events) # 1ヶ月分まとめて
      date = Date.parse("#{year_month}-1")
      all_dates = (date..date.next_month).map { |d| d.strftime("%d") }
      
      hash = {}
      all_dates.each { |date| hash[date] = [] }

      events.each do |event|
        hash[event.date] << {
          name: event.name,
          url: event.url,
          booking_required: event.booking_required
        }
      end

      item = {
        year_month: date.strftime("%Y-%m"),
        data: hash.to_json
      }

      DynamoDB.put(TABLE_NAME, item)
    end

    def where(year: nil, month: nil, date: nil)
      # year yyyy
      # month mm
      # date dd

      key = {
        year_month: '2021-01',
        date_and_id: '04-1' # あとで消す
      }

      DynamoDB.get(TABLE_NAME, key)
    end
  end

  def initialize(year_month:, date:, name:, url:, booking_required:)
    @year_month = year_month
    @date = date
    @name = name
    @url = url
    @booking_required = booking_required
  end
end