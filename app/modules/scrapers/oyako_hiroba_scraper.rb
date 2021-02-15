require 'nokogiri'
require 'open-uri'
require_relative '../../models/kosodate_event.rb'
require 'pry'

class OyakoHirobaScraper
  URL = 'http://www.city.musashino.lg.jp/shiminsanka/kodomokatei/kodomoseisaku/1012272.html'.freeze

  class << self
    def run
      com_center_events
    end

    private 

    def doc
      return @doc unless @doc.nil?
      charset = 'utf-8'
      html = URI.open(URL) { |f| f.read }
      document = Nokogiri::HTML.parse(html, nil, charset)

      # <br>タグを改行（\n）に変えておくとスクレイピングしやすくなる。
      document.search('br').each { |n| n.replace("\n") }

      document
    end

    def com_center_calendar
      return @com_center_calendar unless @com_center_calendar.nil?

      @com_center_calendar = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/div[@id='voice']/table[1]/tbody")
    end

    # コミセン親子ひろば
    def com_center_events
      rows = com_center_calendar.xpath("tr") # 1行目はヘッダなので除く

      events = rows.map do |row|
        date_element = row.xpath("td[3]").text
        date = Date.strptime(date_element, '%m月%d日')

        place = row.xpath("td[1]").text
        [date, place]
      rescue Date::Error
        # 「コミセン工事の為休館」などの場合パースエラーになるため
        # 開催しないということなので、nilを返す
      end

      events.compact!

      # KosodateEventインスタンスを一括で生成する
      events.map! do |event|
        KosodateEvent.new(
          date: event[0],
          name: "コミセン親子ひろば",
          place: event[1],
          url: URL,
          booking_required: true
        )
      end
    end
  end
end

OyakoHirobaScraper.run