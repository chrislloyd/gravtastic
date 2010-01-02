begin
  require 'jeweler'
  Jeweler::Tasks.new do |gs|
    gs.name              = 'gravtastic'
    gs.homepage          = 'http://github.com/chrislloyd/gravtastic'
    gs.description       = 'Add Gravatars to your Rubies/Rails!'
    gs.summary           = 'Ruby/Gravatar'
    gs.email             = 'christopher.lloyd@gmail.com'
    gs.author            = 'Chris Lloyd'
    gs.rubyforge_project = 'gravtastic'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Install jeweler to build gem"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--color']
  t.spec_files = FileList['spec/*.rb']
end
