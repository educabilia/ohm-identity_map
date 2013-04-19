require File.expand_path("lib/ohm/identity_map", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name              = "ohm-identity_map"
  s.version           = Ohm::IdentityMap::VERSION
  s.summary           = "Basic identity map for Ohm."
  s.authors           = ["Educabilia", "Damian Janowski"]
  s.email             = ["opensource@educabilia.com", "djanowski@dimaion.com"]
  s.homepage          = "https://github.com/educabilia/ohm-identity_map"

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test}/*`.split("\n")

  s.add_development_dependency "ohm"
  s.add_development_dependency "cutest"
end
