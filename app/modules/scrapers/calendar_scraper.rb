require 'nokogiri'
require 'open-uri'
require_relative '../../models/kosodate_event.rb'

class CalendarScraper
  CURRENT_MONTH_URL = "http://www.city.musashino.lg.jp/cgi-evt/event/event.cgi?cate=7".freeze
  CONTENT_XPATH = "//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']".freeze

  class << self
    def run(next_month: false)
      calendar_table = next_month ? next_month_calendar : current_month_calendar

      events = scrape(calendar_table)
      events = convert_to_kosodate_event(events)

      KosodateEvent.bulk_insert(events)
    end

    private

    def next_month_calendar
      doc(next_month_url).xpath("#{CONTENT_XPATH}/table[@id='event']")
    end

    # 「翌月を見る」のリンク
    def next_month_url
      doc(CURRENT_MONTH_URL).xpath("#{CONTENT_XPATH}/ul[@class='month'][1]/li[@class='next']/a").attribute("href").value
    end

    def current_month_calendar
      doc(CURRENT_MONTH_URL).xpath("#{CONTENT_XPATH}/table[@id='event']")
    end

    def doc(url)
      charset = 'utf-8'
      html = URI.open(url) { |f| f.read }
      document = Nokogiri::HTML.parse(html, nil, charset)

      # <br>タグを改行（\n）に変えておくとスクレイピングしやすくなる。
      document.search('br').each { |n| n.replace("\n") }

      document
    end
    
    def scrape(calendar_table)
      year_month = calendar_table.xpath("caption").text.scan(/\d+/).join("-") # 例：2021-1
      rows = calendar_table.xpath("tr")[1..] # 1行目はヘッダなので除く

      # 1列に複数日付が入っている場合があるので、まずは [日付, イベント名]の組を作る
      events = rows.map do |row|
        date_element = row.xpath("th").text.scan(/\d+/)[0]
        date = Date.parse("#{year_month}-#{date_element}") 
        
        event_list = row.xpath("td/ul/li")
        event_list.map { |event| [date, event]}
      end

      # before [[[<#Date>, <#Element>], [<#Date>, <#Element>]], [[<#Date>, <#Element>]]]
      # after  [[<#Date>, <#Element>], [<#Date>, <#Element>], [<#Date>, <#Element>]]
      events.flatten!(1)
    end

    def convert_to_kosodate_event(events)
      events.map! do |event|
        KosodateEvent.new(
          date: event[0],
          name: event[1].xpath("a").text,
          url: "http://www.city.musashino.lg.jp" + event[1].xpath("a").attribute("href").value,
          booking_required: event[1].text.include?("事前申込必要")
      )
      end
    end
  end
end
