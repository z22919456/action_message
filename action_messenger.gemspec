lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'action_messenger/version'

Gem::Specification.new do |spec|
  spec.name          = 'action_messenger'
  spec.version       = ActionMessenger::VERSION
  spec.authors       = ['Diego Ballona']
  spec.email         = ['root@dballona.com']

  spec.summary       = 'ActionMailer heavily-inspired gem to handle SMS/Text Messages'
  spec.description   = 'ActionMailer heavily-inspired gem to handle SMS/Text Messages'
  spec.homepage      = 'http://github.com/dballona/action_messenger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 5.0.0'
  spec.add_dependency 'actionview', '>= 5.0.0'
  spec.add_dependency 'activejob', '>= 5.0.0'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'codecov', '~> 0.4.3'
  spec.add_development_dependency 'rake', '~> 11.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.14'
end
