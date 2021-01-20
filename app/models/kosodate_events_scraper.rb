require 'nokogiri'
require 'open-uri'
require "pry"

class KosodateEventsScraper
  URL = 'http://www.city.musashino.lg.jp/cgi-evt/event/event.cgi?cate=7'.freeze

  # input: -
  # output: KosodateEvents

  class << self
    def run
      doc = setup_doc(URL)
      scrape_calendar(doc)
    end

    private

    def setup_doc(url)
      charset = 'utf-8'
      html = open(url) { |f| f.read }
      doc = Nokogiri::HTML.parse(html, nil, charset)

      # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
      doc.search('br').each { |n| n.replace("\n") }

      doc
    end

    def scrape_calendar(doc)
      calendar_table = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/table[@id='event']")
      year_month = calendar_table.xpath("caption").text.scan(/\d+/).join("-") # 例：2021-1

      rows = calendar_table.xpath("tr")[1..] # 1行目はヘッダなので除く

      items = []
      rows.each do |row|
        date = row.xpath("th").text.scan(/\d+/)[0]
        
        events = row.xpath("td/ul/li")
        events.each do |event|
          title = event.xpath("a").text
          path = event.xpath("a").attribute("href").value
          booking_required = event.text.include?("事前申込必要")

          item = {
            date: Date.parse("#{year_month}-#{date}"), 
            title: title,
            url: "http://www.city.musashino.lg.jp" + path,
            booking_required: booking_required
          }
          items << item
        end
      end

      items
    end
  end
end
