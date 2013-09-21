require 'clockwork'
require 'stalker'

module Clockwork
  configure do |config| 
    config[:tz] = "Asia/Singapore" # change this
  end

  handler do |job| 
    Stalker.enqueue(job)
  end

  every(1.week, 'send.prompt', at: 'Saturday 7:30')
  every(1.week, 'send.digest', at: 'Monday 21:00')
  #every(10.seconds, 'send.prompt') # for testing only
end
