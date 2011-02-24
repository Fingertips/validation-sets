require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

namespace :test do
  Rake::TestTask.new(:rails2) do |t|
    t.libs += %w(test test/test_helper/rails2)
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
  
  desc 'Test the plugin with Rails 3.'
  Rake::TestTask.new(:rails3) do |t|
    t.libs += %w(test test/test_helper/rails3)
    t.pattern = 'test/**/*_test.rb'
    t.verbose = true
  end
end

desc 'Run all tests'
task :test => ['test:rails2', 'test:rails3']

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Validation Sets'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "validation-sets"
    s.summary = s.description = "A Rails plugin that adds validation sets to Active Record."
    s.homepage = "http://fingertips.github.com"
    s.email = "manfred@fngtps.com"
    s.authors = ["Manfred Stienstra"]
  end
rescue LoadError
end