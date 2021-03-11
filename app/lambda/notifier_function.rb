require 'json'
require 'line/bot'
require_relative '../models/kosodate_event.rb'
require_relative '../modules/message_formatter.rb'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def run(event:, context:)
  date = Date.today
  events = KosodateEvent.where(year: date.year, month: date.month)
  messages = MessageFormatter.format(events)
  client.broadcast(messages)
end
