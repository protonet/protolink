# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "protolink/version"

Gem::Specification.new do |s|
  s.name = %q{protolink}
  s.version = Protolink::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Björn B. Dorra", "Ali Jelveh"]
  s.description = %q{A Ruby API for interfacing with Protonet, the next-gen internet infrastructure. Truly social and people-powered.}
  s.email = %q{dorra@d-1.comg}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.homepage = %q{http://github.com/protonet/protolink}
  s.rubyforge_project = %q{protolink}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Ruby wrapper for the ProtoNet API}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>, [">= 0"])
      s.add_runtime_dependency(%q<httparty>, ["~> 0.7.4"])
    else
      s.add_dependency(%q<crack>, [">= 0"])
      s.add_dependency(%q<httparty>, ["~> 0.7.4"])
    end
  else
    s.add_dependency(%q<crack>, [">= 0"])
    s.add_dependency(%q<httparty>, ["~> 0.7.4"])
  end
end

