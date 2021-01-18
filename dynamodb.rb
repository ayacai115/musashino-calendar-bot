# ローカルでテーブルを作成するコマンド 
# be ruby dynamodb.rb

# dev, prodはserverless.ymlで設定

require 'aws-sdk-dynamodb'
require 'pry'

def run_me
  Aws.config.update(
    endpoint: 'http://localhost:8000', # ローカル専用
    region: 'ap-northeast-1'
  )

  dynamodb_client = Aws::DynamoDB::Client.new

  table_definition = {
    table_name: 'events',
    key_schema: [
      {
        attribute_name: 'year_month',
        key_type: 'HASH'  # Partition key.
      },
      {
        attribute_name: 'date_and_id',
        key_type: 'RANGE' # Sort key.
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'year_month',
        attribute_type: 'N'
      },
      {
        attribute_name: 'date_and_id',
        attribute_type: 'N'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 1,
      write_capacity_units: 1
    }
  }

  create_table_result = create_table(dynamodb_client, table_definition)

  if create_table_result == 'Error'
    puts 'Table not created.'
  else
    puts "Table created with status '#{create_table_result}'."
  end
end

def create_table(dynamodb_client, table_definition)
  response = dynamodb_client.create_table(table_definition)
  response.table_description.table_status
rescue StandardError => e
  puts "Error creating table: #{e.message}"
  'Error'
end

run_me
