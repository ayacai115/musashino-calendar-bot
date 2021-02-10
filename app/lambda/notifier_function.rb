require 'json'
require 'line/bot'
require_relative '../models/kosodate_event.rb'
require 'pry'

DAYS_OF_THE_WEEK = %w(日 月 火 水 木 金 土)

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

  schedule = schedule.map do |date, events|
    events.map! { |event| "\n#{event['name']} 【事前申込必要】\n #{event['url']}" }

    date = Date.parse(date)
    day_of_the_week = DAYS_OF_THE_WEEK[date.strftime('%w').to_i]
    display_date = date.strftime('%-m月%-d日') + '(' + day_of_the_week + ')' # 例 2月1日(月)

    [display_date, events].flatten!.join('')
  end

  schedule = schedule.join('\n---------------------------\n')

  message = {
    type: 'text',
    text: schedule
  }
  client.broadcast(message)

  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

run(event: nil, context: nil) # テスト用