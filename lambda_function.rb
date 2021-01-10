require 'line/bot'

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
  }
end

def lambda_handler(event:, context:)
  # puts "event: ", event
  # puts "context: ", context.inspect
  
  # ヘッダがあるときだけ署名チェック
  # headers = event["headers"]
  # signiture = headers['X-Line-Signature'] if headers
  
  events = client.parse_events_from(event.to_json)
  events.each do |event|
    case event
    # メッセージだったとき
    when Line::Bot::Event::Message
      case event.type
      # テキストだったとき
      when Line::Bot::Event::MessageType::Text
        message = {
          type: 'text',
          text: event.message['text'] # 同じ言葉を返す
        }
        client.reply_message(event['replyToken'], message)
      # 画像やビデオが来たとき
      when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
        response = client.get_message_content(event.message['id'])
        tf = Tempfile.open("content")
        tf.write(response.body)
      end
    end
  end
    
  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end