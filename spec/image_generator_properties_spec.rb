# frozen_string_literal: true

require 'spec_helper'
require 'overwrites/tool'

describe(Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties) do
  context 'when loading from a dict' do
    it 'uses default values' do
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash({})

      expect(properties.font_properties.font_color).to eql('white')
      expect(properties.font_properties.font).to eql('montserrat-Light')
      expect(properties.font_properties.max_pointsize).to eql(200)
      expect(properties.font_properties.min_pointsize).to eql(100)
      expect(properties.image_properties.max_chars_per_line).to eql(30)
      expect(properties.image_properties.image_path).to eql('_background_image.png')
      expect(properties.image_properties.image_color).to eql('#2054df')
      expect(properties.image_properties.image_size).to eql('2048x1024')
    end

    it 'uses provided values' do
      config = {
        'font_color' => 'test',
        'font' => 'test',
        'max_pointsize' => 5,
        'min_pointsize' => 1,
        'max_chars_per_line' => 5,
        'image_path' => 'test',
        'image_color' => 'test',
        'image_size' => 'test'
      }.freeze

      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(config)

      expect(properties.font_properties.font_color).to eql('test')
      expect(properties.font_properties.font).to eql('test')
      expect(properties.font_properties.max_pointsize).to eql(5)
      expect(properties.font_properties.min_pointsize).to eql(1)
      expect(properties.image_properties.max_chars_per_line).to eql(5)
      expect(properties.image_properties.image_path).to eql('test')
      expect(properties.image_properties.image_color).to eql('test')
      expect(properties.image_properties.image_size).to eql('test')
    end

    it 'uses half max point as min default' do
      config = { 'max_pointsize' => 6 }.freeze

      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(config)
      expect(properties.font_properties.min_pointsize).to eql(3)
    end
  end
end
