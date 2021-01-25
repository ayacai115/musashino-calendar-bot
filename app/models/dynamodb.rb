require 'aws-sdk-dynamodb'
require 'pry'

class DynamoDB
  class << self
    # TODO: 指定した月のイベントを削除する
    # ※更新時、全件削除したほうが差分をとるよりも楽なため
    def delete_events_in(year_month)
    end

    def put(event) # 1件insert
      item = {
        year_month: "#{event.date.year}-#{event.date.month}",
        date_and_id: "#{event.date.day}-2",
        name: event.name,
        url: event.url,
        booking_required: event.booking_required
      }

      table_item = {
        table_name: 'musashino-kosodate-events-local',
        item: item
      }

      client.put_item(table_item)
    end
    

    private

    def client
      return @client unless @client.nil?

      Aws.config.update(
      endpoint: 'http://localhost:8000', # ローカル専用
      region: 'ap-northeast-1'
      )

      @client = Aws::DynamoDB::Client.new
    end
  end
end
