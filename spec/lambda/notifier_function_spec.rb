require_relative '../../app/lambda/notifier_function.rb'
require_relative '../../app/modules/kosodate_event_integrator.rb'

RSpec.describe 'Lambda notifier_function' do
  describe ".run" do
    example "とりあえず例外が出ないことの確認" do
      # テスト用データの用意
      today = Date.today
      year = today.year
      month = today.month

      (1..28).each do |i| # 2月が28日までのため
        create(:kosodate_event, date: Date.new(year, month, i))
      end

      allow_any_instance_of(Line::Bot::Client).to receive(:broadcast)
      
      run(event: nil, context: nil)
    end
  end
end
