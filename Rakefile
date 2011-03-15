require 'rake/gempackagetask'
require 'rake/clean'
require 'rspec/core/rake_task'

def name
  @name ||= File.basename(Dir['*.gemspec'].first, '.gemspec')
end

def gemspec_file
  "#{name}.gemspec"
end

load(gemspec_file)

Rake::GemPackageTask.new(@spec) do |t|
  t.need_tar = true
  t.need_zip = true
end
CLEAN.add 'pkg'

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Build documentation'
task :doc do
  sh 'docco lib/gravtastic.rb'
end
CLEAN.add 'docs'
