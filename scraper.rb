require 'nokogiri'
require 'open-uri'
require "pry"

URL = 'http://www.city.musashino.lg.jp/cgi-evt/event/event.cgi?cate=7'.freeze

def run(event:, context:)
  doc = setup_doc(URL)

  calendar_table = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/table[@id='event']")
  year_month = year_month = calendar_table.xpath("caption").text.scan(/\d+/).join("-") # 例：2021-1

  rows = calendar_table.xpath("tr")[1..] # 1行目はヘッダなので除く

  table_items = []
  rows.each do |row|
    date = row.xpath("th").text.scan(/\d+/)[0]
    
    events = row.xpath("td/ul/li")
    events.each do |event|
      title = event.xpath("a").text
      path = event.xpath("a").attribute("href").value
      booking_required = event.text.include?("事前申込必要")

      table_item = {
        date: "#{year_month}-#{date}", # Dateでパースt
        title: title,
        url: "http://www.city.musashino.lg.jp" + path,
        booking_required: booking_required
      }
      table_items << table_item
    end
  end
  
  # TODO: DynamoDBにinsert/update
  # TODO: 既存のデータとのdiffのみを更新する処理を追加

  # { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end

def setup_doc(url)
  charset = 'utf-8'
  html = open(url) { |f| f.read }
  doc = Nokogiri::HTML.parse(html, nil, charset)

  # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
  doc.search('br').each { |n| n.replace("\n") }

  doc
end

# run(event: nil, context: nil) # テスト用