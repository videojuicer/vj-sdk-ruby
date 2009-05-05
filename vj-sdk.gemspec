# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{vj-sdk}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["danski", "thejohnny", "knowtheory", "sixones"]
  s.date = %q{2009-05-05}
  s.email = %q{dan@videojuicer.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.markdown",
    "README.rdoc",
    "Rakefile",
    "lib/vj_sdk.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/vj_sdk_spec.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/danski/vj-sdk}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/vj_sdk_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.3"])
    else
      s.add_dependency(%q<oauth>, [">= 0.3.3"])
    end
  else
    s.add_dependency(%q<oauth>, [">= 0.3.3"])
  end
end
