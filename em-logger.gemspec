# encoding: utf-8
require File.expand_path('../lib/em-logger/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'em-logger'
  gem.version     = EventMachine::Logger::VERSION
  gem.homepage    = 'https://github.com/spagalloco/em-logger'

  gem.author      = "Steve Agalloco"
  gem.email       = 'steve.agalloco@gmail.com'
  gem.description = %q{TODO: Write a gem description}
  gem.summary     = %q{TODO: Write a gem summary}

  gem.add_dependency "eventmachine", ">= 1.0.0.beta.3"

  gem.add_development_dependency 'rake', '~> 0.9'
  gem.add_development_dependency 'rdiscount', '~> 1.6'
  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'simplecov', '~> 0.5'
  gem.add_development_dependency 'yard', '~> 0.7'
  gem.add_development_dependency 'em-ventually'

  gem.executables = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  gem.files       = `git ls-files`.split("\n")
  gem.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  gem.require_paths = ['lib']
end
