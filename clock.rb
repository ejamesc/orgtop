require 'clockwork'
require 'stalker'

module Clockwork
  configure do |config| 
    config[:tz] = "America/Los_Angeles" # change this
  end

  handler do |job| 
    Stalker.enqueue(job)
  end

  #every(1.week, 'send.prompt', at: 'Wednesday 22:25')
  every(10.seconds, 'send.prompt')
end
