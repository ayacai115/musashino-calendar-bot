require 'json'
require 'line/bot'
require_relative '../models/kosodate_event.rb'
require_relative '../modules/broadcast_formatter.rb'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def run(event:, context:)
  result = KosodateEvent.where(year: '2021', month: '02')
  result.item['data']

  schedule = JSON.parse(result.item['data'])
  messages = BroadcastFormatter.format(schedule)
  client.broadcast(messages)

  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用