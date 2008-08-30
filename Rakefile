require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'spec/rake/spectask'
require 'date'

GEM = "gravtastic"
GEM_VERSION = "1.7.0"
AUTHOR = "Chris Lloyd"
EMAIL = "christopher.lloyd@gmail.com"
HOMEPAGE = "http://github.com/chrislloyd/gravtastic"
SUMMARY = "Easily add Gravatars to your Ruby objects."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = GEM
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile', 'LICENSE']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  # s.add_dependency "foo"
  
  s.require_path = 'lib'
  s.files = %w(LICENSE README.textile Rakefile) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :default => :spec
task :specs => :spec

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--options','spec/spec.opts']
  t.spec_files = FileList['spec/**/*.rb']
  t.rcov = true
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

task :bugs do
  sh %{ditz html ; open html/index.html}
end
