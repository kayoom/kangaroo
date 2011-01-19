require 'rake'
require 'rake/rdoctask'
require 'rspec/core/rake_task'
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

desc 'Run RSpec suite.'
RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec