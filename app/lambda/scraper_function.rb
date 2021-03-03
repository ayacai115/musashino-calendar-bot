require 'aws-sdk-dynamodb'
require_relative '../modules/kosodate_event_integrator.rb'

def run(event:, context:)
  # 今月
  KosodateEventIntegrator.run

  # 来月
  KosodateEventIntegrator.run(next_month: true)
end
