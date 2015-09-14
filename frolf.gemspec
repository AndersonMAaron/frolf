Gem::Specification.new do |s|
  s.name        = 'dgbuddy'
  s.version     = '0.0.1'
  s.date        = '2015-07-08'

  s.summary     = 'Disc Golf Buddy'
  s.description = 'Disc Golf Buddy: For everything disc golf.'
  s.homepage    = 'http://frolfbuddy.com' # but I'll need to buy it
  s.authors     = ['Aaron M Anderson']
  s.email       = 'andersonmaaron@gmail.com'
  s.license     = 'MIT'

  s.executables = ['recommendisc']

  s.files       = Dir['lib/**/*.rb']

  s.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_development_dependency 'rspec', '~> 3.2'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.2'
  s.add_development_dependency 'simplecov', '~> 0.9', '>= 0.9.1'

  s.add_runtime_dependency 'json', '~> 1.8'
end
