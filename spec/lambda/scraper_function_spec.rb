require_relative '../../app/lambda/scraper_function.rb'

RSpec.describe 'Lambda scraper_function' do
  describe ".run" do
    example "とりあえず例外が出ないことの確認" do
      run(event: nil, context: nil)
    end
  end
end
