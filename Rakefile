require 'rubygems/package_task'
require 'rake/clean'
require 'rspec/core/rake_task'

def name
  @name ||= File.basename(Dir['*.gemspec'].first, '.gemspec')
end

def gemspec_file
  "#{name}.gemspec"
end

load(gemspec_file)

Gem::PackageTask.new(@spec) do |t|
  t.need_tar = true
  t.need_zip = true
end
CLEAN.add 'pkg'

require 'spec/rake/spectask'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ['--color', '--require ./spec/helper']
end
