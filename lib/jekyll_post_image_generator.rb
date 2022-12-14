# frozen_string_literal: true

require 'jekyll'
require 'jekyll-post-image-generator/generator'
require 'jekyll-post-image-generator/image_tag'

module JekyllPostImageGenerator
  DEFAULTS = {
    'background_image' => '_background_image.png',
    'output_directory' => File.join('assets', 'images', 'title_images'),
    'max_pointsize' => 200,
    'min_pointsize' => 100,
    'max_columns_per_line' => 30,
    'font' => 'montserrat-Thin',
    'font_color' => 'white'
  }.freeze
end
