# encoding: UTF-8

require 'bundler'
require 'rake/rdoctask'
require 'rspec/core/rake_task'

# bundler tasks for publishing gems
Bundler::GemHelper.install_tasks

# rdoc task to produce documentation
Rake::RDocTask.new do |rd|
  rd.main          = "README.rdoc"
  rd.inline_source = false

  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

# rspec task for tests, the default task
RSpec::Core::RakeTask.new
task :default => :spec
