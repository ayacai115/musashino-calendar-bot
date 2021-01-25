require_relative '../modules/dynamodb.rb'

class KosodateEvent
  TABLE_NAME = 'musashino-kosodate-events-local'.freeze
  attr_reader :year_month, :date_and_id, :name, :url, :booking_required

  class << self
    def bulk_insert(events)
      requests = []
      events.each do |event|
        requests << {
                      put_request: {
                        item: {
                          year_month: { s: event.year_month },
                          date_and_id: { s: event.date_and_id }, 
                          name: { s: event.name },
                          url: { s: event.url },
                          booking_required: { bool: event.booking_required }
                        } 
                      }
                    }
                      
      end

      Aws.config.update(
      endpoint: 'http://localhost:8000', # ローカル専用
      region: 'ap-northeast-1'
      )

      client = Aws::DynamoDB::Client.new

      client.batch_write_item({
        request_items: {
          TABLE_NAME: requests
        }
      })
    end

    def where(year: nil, month: nil, date: nil)
      # year yyyy
      # month mm
      # date dd

      key = {
        year_month: '2021-01',
        date_and_id: '04-1'
      }

      DynamoDB.get(TABLE_NAME, key)
    end
  end

  def initialize(year_month:, date_and_id:, name:, url:, booking_required:)
    @year_month = year_month
    @date_and_id = date_and_id
    @name = name
    @url = url
    @booking_required = booking_required
  end
end