# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lanyon/version'

Gem::Specification.new do |spec|
  spec.name          = 'lanyon'
  spec.version       = Lanyon::VERSION

  spec.authors       = ['Zachary Elliott']
  spec.email         = ['zach@nyu.edu']

  spec.summary       = %q{Lanyon: Light CMS for Jekyll}
  spec.description   = %q{Git backed CMS for Jekyll with a dynamic web editor.}

  spec.homepage      = 'https://github.com/zellio/lanyon'

  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'simplecov', '~> 0.8'
  spec.add_development_dependency 'fakefs', '~> 0.5'
end
