require_relative '../../app/lambda/line_bot_function.rb'

RSpec.describe 'Lambda line_bot_function' do
  describe ".run" do
    example "とりあえず例外が出ないことの確認" do
      event = {
        "body" =>  {
          "events":[
            {
              "type":"message",
              "replyToken":"5d80a999899c4725b88a6bb045f7000",
              "source":{
                "userId":"U83d87a70283f1a1d40021aa0d0000000",
                "type":"user"
              },
              "timestamp":1615182250115,
              "mode":"active",
              "message":{
                "type":"text",
                "id":"13679588938950",
                "text":"てす"
              }
            }
          ],
          "destination":"Ue909df35bca265c9c3714d97000000"
        }.to_json,
        "replyToken": "hoge"
      }

      allow_any_instance_of(Line::Bot::Client).to receive(:reply_message)
      
      answer(event: event, context: nil)
    end
  end
end
