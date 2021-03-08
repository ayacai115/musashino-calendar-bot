module ReplyFormatter
  MAPPING = {
    "今月" => Date.today.month,
    "来月" => Date.today.next_month.month
  }

  class << self
    def format(text)
      # 検索
      # 日付、場所名を探して
    end
  end
end