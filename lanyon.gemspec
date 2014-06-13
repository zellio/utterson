# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lanyon/version'

Gem::Specification.new do |spec|
  spec.name          = 'lanyon'
  spec.version       = Lanyon::VERSION

  spec.authors       = ['Zachary Elliott']
  spec.email         = ['zach@nyu.edu']

  spec.summary       = %q(Lanyon: Light CMS for Jekyll)
  spec.description   = %q(Git backed CMS for Jekyll with a dynamic web editor.)

  spec.homepage      = 'https://github.com/zellio/lanyon'

  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'simplecov', '~> 0.8'
  spec.add_development_dependency 'fakefs', '~> 0.5'

  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'sinatra-contrib', '~> 1.4'
  spec.add_dependency 'liquid', '~> 2.6'
  spec.add_dependency 'sass', '~> 3.3'
  spec.add_dependency 'rack-coffee', '~> 1.0'
  spec.add_dependency 'rack-parser', '~> 0.6'
  spec.add_dependency 'rugged', '~> 0.19'
  spec.add_dependency 'therubyracer', '~> 0.12'
end
