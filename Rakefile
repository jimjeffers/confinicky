# encoding: utf-8

require 'rubygems'
require 'bundler'
require './lib/confinicky/version.rb'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = "confinicky"
  gem.homepage = "http://github.com/jimjeffers/confinicky"
  gem.license = "MIT"
  gem.summary = "A simple CLI to manage environment variables on your local machine."
  gem.description = "A simple CLI to manage environment variables on your local machine. Perform basic CRUD for your environment variables all in the command line."
  gem.email = "jim@sumocreations.com"
  gem.authors = ["Jim Jeffers"]
  gem.executables = ['cfy']
  gem.version = Confinicky::Version::STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = Confinicky::Version::STRING

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "confinicky #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
