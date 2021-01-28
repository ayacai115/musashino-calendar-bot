require 'aws-sdk-dynamodb'

class DynamoDB
  class << self
    def put(table_name, item)
      client.put_item(table_name: table_name, item: item)
    end

    def get(table_name, key)
      client.get_item(table_name: table_name, key: key)
    end
    

    private

    def client
      return @client unless @client.nil?

      Aws.config.update(
      # endpoint: 'http://localhost:8000', # ローカル専用
      region: 'ap-northeast-1'
      )

      @client = Aws::DynamoDB::Client.new
    end
  end
end
