Gem::Specification.new do |s|
  s.name = %q{gravtastic}
  s.version = "2.1.2"
  s.rubygems_version = %q{2.1.1}

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Lloyd"]
  s.date = %q{2008-09-15}
  s.description = %q{Easily add Gravatars to your Ruby objects.}
  s.email = %q{christopher.lloyd@gmail.com}
  s.files = ["LICENSE", "README.md", "Rakefile", "lib/gravtastic.rb", "spec/gravtastic_integration_spec.rb", "spec/gravtastic_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = false
  s.homepage = %q{http://github.com/chrislloyd/gravtastic}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gravtastic}

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
