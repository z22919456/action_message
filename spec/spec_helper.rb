require 'simplecov'
require 'codecov'
SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::Codecov

require 'webmock/rspec'

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'action_messenger'
