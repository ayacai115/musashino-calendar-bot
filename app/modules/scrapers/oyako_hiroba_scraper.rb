require 'nokogiri'
require 'open-uri'
require_relative '../../models/kosodate_event.rb'

class OyakoHirobaScraper
  URL = 'http://www.city.musashino.lg.jp/shiminsanka/kodomokatei/kodomoseisaku/1012272.html'.freeze

  class << self
    def run(next_month: false)
      events = com_center_events(next_month) + collabono_events(next_month)

      events.map! do |event|
        KosodateEvent.new(
          date: event[0],
          name: "コミセン親子ひろば",
          place: event[1],
          url: URL,
          booking_required: true
        )
      end

      events
    end

    private 

    # コミセン親子ひろば
    def com_center_events(next_month)
      rows = com_center_calendar.xpath("tr") # 1行目はヘッダなので除く
      td = next_month ? "td[3]" : "td[2]"

      events = rows.map do |row|
        date_element = row.xpath(td).text
        date = Date.strptime(date_element, '%m月%d日')

        place = row.xpath("td[1]").text
        [date, place]
      rescue Date::Error
        # 「コミセン工事の為休館」などの場合パースエラーになるため
        # 開催しないということなので、nilを返す
      end

      events.compact!
    end

    def com_center_calendar
      return @com_center_calendar unless @com_center_calendar.nil?

      @com_center_calendar = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/div[@id='voice']/table[1]/tbody")
    end

    # こらぼのコミセン親子ひろば
    def collabono_events(next_month)
      rows = collabono_calendar.xpath("tr") # 1行目はヘッダなので除く
      td = next_month ? "td[3]" : "td[2]"

      events = rows.map do |row|
        date_elements = row.xpath(td).text.split("\n") # 例: "3月1日（月曜日）\n3月15日（月曜日）\n"
        dates = date_elements.map do |d|
          Date.strptime(d, '%m月%d日')
        rescue Date::Error
          # 「出張おもちゃのぐるりん」などでパースエラーになったものはnilを返す
        end

        dates.compact! # パースエラーになったものは排除

        place = row.xpath("td[1]").text
        dates.map! { |date| [date, place] }
      end

      events.flatten!(1) # 1列に複数日付があるため、配列が1段深くなっている
    end

    def collabono_calendar
      return @collabono_calendar unless @collabono_calendar.nil?

      @collabono_calendar = doc.xpath("//div[@id='wrapbg']/div[@id='wrap']/div[@id='pagebody']/div[@id='content']/div[@id='voice']/table[2]/tbody")
    end 

    def doc
      return @doc unless @doc.nil?
      charset = 'utf-8'
      html = URI.open(URL) { |f| f.read }
      document = Nokogiri::HTML.parse(html, nil, charset)

      # <br>タグを改行（\n）に変えておくとスクレイピングしやすくなる。
      document.search('br').each { |n| n.replace("\n") }

      document
    end
  end
end

OyakoHirobaScraper.run