# frozen_string_literal: true

require_relative 'lib/vidload'

Gem::Specification.new do |spec|
  spec.name        = 'vidload'
  spec.version     = Vidload::VERSION
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 3.3'
  spec.authors     = ['Patacode <pata.codegineer@gmail.com>']
  spec.summary     = 'Download videos from web to local'
  spec.files       = Dir['lib/**/*.rb', 'lib/**/*.sh']
  spec.require_paths = ['lib']
  spec.add_dependency 'lucky_case', '~> 1.1'
  spec.add_dependency 'm3u8', '~> 1.8'
  spec.add_dependency 'playwright-ruby-client', '~> 1.58'
  spec.add_dependency 'thor', '~> 1.5'
  spec.add_dependency 'tty-spinner', '~> 0.9'
  spec.add_development_dependency 'gem-release', '~> 2.2'
  spec.add_development_dependency 'rake', '~> 13.3'
  spec.add_development_dependency 'rubocop', '~> 1.85'
end
