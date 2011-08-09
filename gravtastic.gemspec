require './lib/gravtastic/version'

@spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY

  s.name    = 'gravtastic'
  s.version = Gravtastic::VERSION
  s.date    = '2011-08-03'

  s.author   = 'Chris Lloyd'
  s.email    = 'christopher.lloyd@gmail.com'
  s.homepage = 'http://github.com/chrislloyd/gravtastic'

  s.summary     = 'A Ruby wrapper for Gravatar URLs'
  s.description = s.summary

  s.rubyforge_project = 'gravtastic'

  s.has_rdoc = false

  s.require_path = 'lib'
  s.files        = %w(README.md Rakefile Gemfile
    lib/gravtastic
    lib/gravtastic/engine.rb
    lib/gravtastic/version.rb
    lib/gravtastic.rb
    spec/gravtastic_spec.rb
    spec/helper.rb
    vendor/assets
    vendor/assets/javascripts
    vendor/assets/javascripts/gravtastic.coffee
    vendor/assets/javascripts/md5.js
  )
end
