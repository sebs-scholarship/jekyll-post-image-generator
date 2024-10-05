# frozen_string_literal: true

require 'jekyll'
require 'jekyll-post-image-generator/image_generator'
require 'jekyll-post-image-generator/site_processor'
require 'jekyll-post-image-generator/generator'
require 'jekyll-post-image-generator/image_tag'
require 'jekyll-post-image-generator/utils'

module Jekyll
  # Module for JekyllPostImageGenerator
  module JekyllPostImageGenerator
    DEFAULT_OUTPUT_DIR = File.join('assets', 'images')
  end
end
