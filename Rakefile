require 'mg'
require 'spec/rake/spectask'

MG.new('gravtastic.gemspec')

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--options','spec/spec.opts']
  t.spec_files = FileList['spec/**/*.rb']
  # t.rcov = true
end
