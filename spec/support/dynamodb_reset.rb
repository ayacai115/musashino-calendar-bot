require 'aws-sdk-dynamodb'

module DynamodbReset
  TABLE_NAME = "musashino-kosodate-events-local"

  class << self
    def table
      if client.list_tables.table_names.include?(TABLE_NAME)
        client.delete_table(table_name: TABLE_NAME)
      end
      
      client.create_table(table_definition)
    end

    def client
      return @client if defined?(@client)
      
      Aws.config.update({ 
        region: 'ap-northeast-1',
        endpoint: 'http://localhost:8000' 
      })
      @client = Aws::DynamoDB::Client.new
    end

    def table_definition
      {
        table_name: TABLE_NAME,
        key_schema: [
          {
            attribute_name: 'year_month',
            key_type: 'HASH'  # Partition key.
          },
        ],
        attribute_definitions: [
          {
            attribute_name: 'year_month',
            attribute_type: 'S'
          },
        ],
        provisioned_throughput: {
          read_capacity_units: 1,
          write_capacity_units: 1
        }
      }
    end
  end
end
