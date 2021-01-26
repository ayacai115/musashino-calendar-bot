require 'nokogiri'
require 'open-uri'
require "pry"
require_relative '../models/kosodate_event.rb'

class KosodateEventsScraper
  URL = 'http://www.city.musashino.lg.jp/cgi-evt/event/event.cgi?cate=7'.freeze

  class << self
    def run
      # 今月
      year_month = calendar_table.xpath("caption").text.scan(/\d+/).join("-") # 例：2021-1

      rows = calendar_table.xpath("tr")[1..] # 1行目はヘッダなので除く

      events = []
      rows.each do |row|
        date_element = row.xpath("th").text.scan(/\d+/)[0]
        date = Date.parse("#{year_month}-#{date_element}") 
        
        list_items = row.xpath("td/ul/li")

        list_items.each_with_index do |item, i|
          name = item.xpath("a").text
          path = item.xpath("a").attribute("href").value
          booking_required = item.text.include?("事前申込必要")

          events << KosodateEvent.new(
            year_month: date.strftime("%Y-%m"),
            date: date.strftime("%d"),
            name: name,
            url: "http://www.city.musashino.lg.jp" + path,
            booking_required: booking_required
          )
        end
      end

      KosodateEvent.save(year_month, events)
    end

    private

    def calendar_table
      return @calendar_table unless @calendar_table.nil?

      @calendar_table = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/table[@id='event']")
    end

    def doc
      return @doc unless @doc.nil?
      charset = 'utf-8'
      html = URI.open(URL) { |f| f.read }
      document = Nokogiri::HTML.parse(html, nil, charset)

      # <br>タグを改行（\n）に変えて置くとスクレイピングしやすくなる。
      document.search('br').each { |n| n.replace("\n") }

      document
    end
  end
end
