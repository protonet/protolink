require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

# require 'rspec/core/rake_task'
# desc 'Run the specs'
# RSpec::Core::RakeTask.new do |r|
#   r.verbose = false
# end

# task :default => :spec