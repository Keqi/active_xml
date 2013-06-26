# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_xml/version'

Gem::Specification.new do |spec|
  spec.name          = "active_xml"
  spec.version       = ActiveXML::VERSION
  spec.authors       = ["Łukasz Strzebińczyk, Maciej Nowak"]
  spec.email         = ["maciej.nowak90@gmail.com, l.strzebinczyk@gorailsgo.com"]
  spec.description   = %q{Gem provides a number of methods to easily move through xmls}
  spec.summary       = %q{Nokogiri XML Wrapper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_dependency "nokogiri"
  spec.add_dependency 'activesupport'
end
