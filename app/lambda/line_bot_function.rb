require 'json'
require 'line/bot'
require_relative '../modules/reply_formatter.rb'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def answer(event:, context:)
  # ヘッダがあるときだけ署名チェック
  # headers = event["headers"]
  # signiture = headers['X-Line-Signature'] if headers
  
  events = client.parse_events_from(event['body'])
  
  status_code = nil
  line_response = nil

  events.each do |event|
    case event
    # メッセージだったとき
    when Line::Bot::Event::Message
      case event.type
      # テキストだったとき
      when Line::Bot::Event::MessageType::Text
        message = ReplyFormatter.format(event.message['text'])
        puts "input: ", event.message['text']
        puts "message: ", message

        response = client.reply_message(event['replyToken'], message)
        status_code = response.code == "200" ? 200 : 500
        line_response = response
      # 画像やビデオが来たとき
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end

  { statusCode: status_code, body: { line_response: line_response } }
end