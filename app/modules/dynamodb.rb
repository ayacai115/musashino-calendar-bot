require 'aws-sdk-dynamodb'

class DynamoDB
  class << self
    def put(table_name, item)
      client.put_item(table_name: table_name, item: item)
    end

    def get(table_name, key)
      client.get_item(table_name: table_name, key: key)
    end

    def scan(table_name)
      client.scan(table_name: table_name)
    end

    private

    def client
      return @client if defined?(@client)

      Aws.config.update(config_params)
      @client = Aws::DynamoDB::Client.new
    end

    def config_params
      if local?
        { region: 'ap-northeast-1', endpoint: 'http://localhost:8000' }
      else
        { region: 'ap-northeast-1' }
      end
    end
    
    def local?
      ENV["STAGE"].nil?
    end
  end
end
