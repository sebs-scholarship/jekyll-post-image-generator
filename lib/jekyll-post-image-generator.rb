# frozen_string_literal: true

require 'jekyll'
require 'jekyll-post-image-generator/image_generator'
require 'jekyll-post-image-generator/site_processor'
require 'jekyll-post-image-generator/generator'
require 'jekyll-post-image-generator/image_tag'

module Jekyll
  module JekyllPostImageGenerator
    DEFAULTS = {
      'background_image' => '_background_image.png',
      'output_directory' => File.join('assets', 'images'),
      'max_pointsize' => 200,
      'max_columns_per_line' => 30,
      'font' => 'montserrat-Light',
      'font_color' => 'white'
    }.freeze
  end
end
