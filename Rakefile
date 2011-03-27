# encoding: UTF-8

require 'bundler'
require 'rspec/core/rake_task'

# add bundler tasks for publishing gems
Bundler::GemHelper.install_tasks

# add rspec task for tests and make it the default
RSpec::Core::RakeTask.new
task :default => :spec
