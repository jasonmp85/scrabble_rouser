# encoding: UTF-8

$:.push File.expand_path('../../lib', __FILE__)

require 'bundler/setup'
require 'rspec'

require 'benchmark'

require 'simplecov'
SimpleCov.start

require 'scrabble_rouser'

# this matcher allows assertions about performance
RSpec::Matchers.define :take_less_than do |n|
  chain :seconds do; end
  chain :second do; end

  match do |block|
    @elapsed = Benchmark.realtime do
      block.call
    end
    @elapsed <= n
  end

  failure_message_for_should do |actual|
    "expected a runtime under #{n} seconds, but observed #{@elapsed}"
  end
end

class String
  def to_b
    bytes.first
  end
end