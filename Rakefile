require 'rake'
require 'rake/rdoctask'
require 'bundler'

Bundler::GemHelper.install_tasks

#TODO: sdoc
desc 'Generate KangARoo rdoc.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'KangARoo'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rspec/core/rake_task'
  desc 'Run RSpec suite.'
  RSpec::Core::RakeTask.new('spec')
rescue LoadError
  puts "RSpec is not available. In order to run specs, you must: gem install rspec"
end

begin
  require 'cucumber/rake/task'
  desc "Run Cucumber features."
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: gem install cucumber"
end



# If you want to make this the default task
task :default => :spec