require 'aws-sdk-dynamodb'
require 'pry'

class DynamoDB
  class << self
    def list_tables
    end

    def create_events_in(months)
      
    end

    # 指定した月のイベントを削除する
    # ※更新時、全件削除したほうが差分をとるよりも楽なため
    def delete_events_in(months)
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

DynamoDB.list_tables