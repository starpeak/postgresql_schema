# encoding: UTF-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = "postgresql_schema"
  s.summary = %Q{Use PostgreSQL schemas for storing different Rails environments.}
  s.description = %Q{Use PostgreSQL schemas for storing different Rails environments.}
  s.email = 'info@spom.net'
  s.homepage = 'http://spom.net/'
  s.authors = ['Sven G. Broenstrup']
  s.files = Dir["{lib}/**/*", "VERSION", "README*", "LICENCE", "Gemfile"]
  s.version = ::File.read(::File.join(::File.dirname(__FILE__), "VERSION")).strip
  s.add_dependency 'rails', '>= 3.0.0'
  s.add_dependency 'pg', '>= 3.0.0'
end

Rake::GemPackageTask.new(spec) do |pkg|
end

desc "Create a stand-alone gemspec"
task :gemspec  do
  open("#{spec.name}.gemspec", "w") do |f| 
    f.puts "# Generated by rake\n# DO NOT EDIT THIS FILE DIRECTLY\n"
    f.puts spec.to_ruby 
  end
end

task :gem => [:gemspec]

desc "Install the gem #{spec.name}-#{spec.version}.gem"
task :install do
  system("gem install pkg/#{spec.name}-#{spec.version}.gem --no-ri --no-rdoc")
end
task :install => [:gem]
