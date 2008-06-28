Gem::Specification.new do |s|
  s.name = %q{gravtastic}
  s.version = "1.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Lloyd"]
  s.date = %q{2008-06-28}
  s.description = %q{Easily add Gravatars to your Ruby objects.}
  s.email = %q{christopher.lloyd@gmail.com}
  s.extra_rdoc_files = ["README.textile", "LICENSE"]
  s.files = ["LICENSE", "README.textile", "Rakefile", "lib/gravtastic.rb", "spec/gravtastic_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/chrislloyd/gravtastic}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gravtastic}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Easily add Gravatars to your Ruby objects.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
