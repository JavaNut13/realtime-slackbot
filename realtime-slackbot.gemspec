Gem::Specification.new do |s|
  s.name        = 'realtime-slackbot'
  s.version     = '0.0.1'
  s.date        = '2016-03-18'
  s.summary     = "Slackbot realtime API"
  s.description = "Library for making realtime bots and responding to messages"
  s.authors     = ["Will Richardson"]
  s.email       = 'william.hamish@gmail.com'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'http://github.com/javanut13/realtime-slackbot'
  s.license     = 'MIT'
  s.add_runtime_dependency 'faye-websocket', '~> 0.10'
  s.add_runtime_dependency 'eventmachine', '~> 1.0'
end