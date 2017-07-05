# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kps/version'

Gem::Specification.new do |spec|
  spec.name          = 'kps'
  spec.version       = Kps::VERSION.dup
  spec.authors       = ['Uzem Yazılım Birimi']
  spec.email         = ['teknik@uzem.omu.edu.tr']

  spec.summary       = 'Omu Kimlik Paylasım Sistemi'
  spec.description   = 'Omu Kimlik Paylasım Sistemi'
  spec.homepage      = 'http://github.com/uzem/kps'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'savon', '>= 2.7.2'
  spec.add_development_dependency 'bundler', '~> 1.13.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rubocop'
end
