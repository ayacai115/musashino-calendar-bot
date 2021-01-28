require 'aws-sdk-dynamodb'

def run
  Aws.config.update(
    endpoint: 'http://localhost:8000',
    region: 'ap-northeast-1'
  )

  create_table_result = create_table(dynamodb_client, table_definition)

  if create_table_result == 'Error'
    puts 'Table not created.'
  else
    puts "Table created with status '#{create_table_result}'."
  end
end

private

def create_table(dynamodb_client, table_definition)
  response = dynamodb_client.create_table(table_definition)
  response.table_description.table_status
rescue StandardError => e
  puts "Error creating table: #{e.message}"
  'Error'
end

def dynamodb_client
  Aws::DynamoDB::Client.new
end

def table_definition
  {
    table_name: 'musashino-kosodate-events-local',
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

run