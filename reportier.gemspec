require 'lib/reportier/version'

Gem::Specification.new do |s|
  s.name          = 'reportier'
  s.version       = Reportier::VERSION
  s.date          = '2016-06-13'
  s.summary       = "A stat tracker that reports"
  s.description   = "A stat tracker that reports automatically as you just add items"
  s.authors       = ["Vasilis Spilka"]
  s.email         = 'vasspilka@gmail.com'
  s.files         = 'git ls-files -- lib/* README.md CHANGELOG.md'.split($/)
  s.require_paths = ['lib']
  s.homepage      = 'http://rubygems.org/gems/reportier'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.2.0'
end

