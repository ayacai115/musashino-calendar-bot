require_relative '../modules/dynamodb.rb'
require 'pry'

class KosodateEvent
  TABLE_NAME = "musashino-kosodate-events-#{ENV['STAGE'] || 'local'}".freeze
  
  attr_reader :date
  attr_reader :name
  attr_reader :url 
  attr_reader :booking_required

  class << self
    def bulk_save(events) # 1ヶ月分まとめて
      # ここイケてない
      # ある日付だけ入れればよいのでは？
      # たしかmapの性質の問題だっけ…うーむ
      # date = Date.parse("#{year_month}-1")
      # all_dates = (date..date.next_month).map { |d| d.strftime("%d") }
      
      # hash = {}
      # all_dates.each { |date| hash[date] = [] }

      # events.each do |event|
      #   hash[event.date] << {
      #     name: event.name,
      #     url: event.url,
      #     booking_required: event.booking_required
      #   }
      # end

      item = {
        year_month: events.first.date.strftime("%Y-%m"),
        data: events.group_by { |event| event.date.strftime("%Y-%m-%d") }.to_json,
        created_at: DateTime.now.new_offset('+9').strftime('%Y-%m-%d %H:%M')
      }

      DynamoDB.put(TABLE_NAME, item)
    end

    # year: yyyy, month: mm
    def where(year: nil, month: nil)
      key = {
        year_month: [year, month].join('-')
      }

      DynamoDB.get(TABLE_NAME, key)
    end
  end

  def initialize(date:, name:, url:, booking_required:)
    @date = date
    @name = name
    @url = url
    @booking_required = booking_required
  end
end