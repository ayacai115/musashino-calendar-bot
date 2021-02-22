require 'aws-sdk-dynamodb'

TABLE_NAME = 'musashino-kosodate-events-local'.freeze

def run
  Aws.config.update(
    endpoint: 'http://localhost:8000',
    region: 'ap-northeast-1'
  )

  delete_table if client.list_tables.table_names.include?(TABLE_NAME)

  create_table_result = create_table

  if create_table_result == 'Error'
    puts 'Table not created.'
  else
    puts "Table created with status '#{create_table_result}'."
  end
end

private

def delete_table
  client.delete_table(table_name: TABLE_NAME)
end

def create_table
  response = client.create_table(table_definition)
  response.table_description.table_status
rescue StandardError => e
  puts "Error creating table: #{e.message}"
  'Error'
end

def client
  Aws::DynamoDB::Client.new
end

def table_definition
  {
    table_name: TABLE_NAME,
    key_schema: [
      {
        attribute_name: 'date',
        key_type: 'HASH'  # Partition key.
      },
      {
        attribute_name: 'name',
        key_type: 'RANGE'  # Partition key.
      }
    ],
    attribute_definitions: [
      {
        attribute_name: 'date',
        attribute_type: 'S'
      },
      {
        attribute_name: 'name',
        attribute_type: 'S'
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 1,
      write_capacity_units: 1
    }
  }
end

run