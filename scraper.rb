require 'nokogiri'
require 'open-uri'

def run(event:, context:)
  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end