require 'nokogiri'
require 'open-uri'
require_relative '../models/kosodate_event.rb'

class KosodateEventsScraper
  URL = 'http://www.city.musashino.lg.jp/cgi-evt/event/event.cgi?cate=7'.freeze

  class << self
    def run
      # 今月
      year_month = calendar_table.xpath("caption").text.scan(/\d+/).join("-") # 例：2021-1
      rows = calendar_table.xpath("tr")[1..] # 1行目はヘッダなので除く

      events = rows.map do |row|
        date_element = row.xpath("th").text.scan(/\d+/)[0]
        date = Date.parse("#{year_month}-#{date_element}") 
        
        event_list = row.xpath("td/ul/li")
        event_list.map { |event| [date, event]}
      end

      # before [[[<#Date>, <#Element>], [<#Date>, <#Element>]], [[<#Date>, <#Element>]]]
      # after  [[<#Date>, <#Element>], [<#Date>, <#Element>], [<#Date>, <#Element>]]
      events.flatten!(1) 

      events.map! do |event|
        KosodateEvent.new(
          date: event[0],
          name: event[1].xpath("a").text,
          url: "http://www.city.musashino.lg.jp" + event[1].xpath("a").attribute("href").value,
          booking_required: event[1].text.include?("事前申込必要")
        )
      end

      KosodateEvent.bulk_save(events)
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
