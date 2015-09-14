begin
  require 'simplecov'

  SimpleCov.configure do
    add_filter '/spec/'
    minimum_coverage 1
    refuse_coverage_drop
  end

  SimpleCov.start
rescue LoadError
  puts "Coverage is disabled - install simplecov to enable."
end

require_relative './frolf/fixtures/test_bag'

# Load modules to test
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'frolf'
require 'frolf/bag'
require 'frolf/caddie'
require 'frolf/disc'
