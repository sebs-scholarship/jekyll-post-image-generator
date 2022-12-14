# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name             = 'jekyll-post-image-generator'
  spec.version          = '0.0.1'
  spec.authors          = ['Levi Muniz', 'https://github.com/sebs-scholarship/jekyll-post-image-generator/graphs/contributors']
  spec.email            = ['levi.muniz17@gmail.com']
  spec.summary          = 'A Jekyll plugin to generate a title image for your Jekyll posts'
  spec.homepage         = 'https://github.com/sebs-scholarship/jekyll-post-image-generator' # TODO: Add github link
  spec.license          = 'Apache-2.0'

  spec.files            = Dir['lib/**/*']
  spec.extra_rdoc_files = Dir['README.md', 'LICENSE']
  spec.test_files       = spec.files.grep(%r{^spec/})
  spec.require_paths    = ['lib']

  spec.required_ruby_version = '>= 2.6.10'

  spec.add_dependency 'jekyll', '>= 4.3.1'
  spec.add_dependency 'mini_magick', '>= 4.11.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
