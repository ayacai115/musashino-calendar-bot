require 'aws-sdk-dynamodb'
require 'pry'

class DynamoDB
  class << self
    # TODO: 指定した月のイベントを削除する
    # ※更新時、全件削除したほうが差分をとるよりも楽なため
    def delete_events_in(year_month)
    end

    def put(table_name, item) # 1件insert
      client.put_item(table_name: table_name, item: item)
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
