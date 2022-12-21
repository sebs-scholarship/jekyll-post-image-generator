# frozen_string_literal: true

require 'spec_helper'
require 'overwrites/tool'

describe(Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties) do
  context 'when loading from a dict' do
    it 'uses default values' do
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({})

      expect(properties.font_color).to eql('white')
      expect(properties.font).to eql('montserrat-Thin')
      expect(properties.max_columns_per_line).to eql(30)
      expect(properties.max_pointsize).to eql(200)
      expect(properties.min_pointsize).to eql(100)
    end

    it 'uses provided values' do
      config = {
        'font_color' => 'test',
        'font' => 'test',
        'max_columns_per_line' => 5,
        'max_pointsize' => 5,
        'min_pointsize' => 1
      }.freeze

      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict(config)

      expect(properties.font_color).to eql('test')
      expect(properties.font).to eql('test')
      expect(properties.max_columns_per_line).to eql(5)
      expect(properties.max_pointsize).to eql(5)
      expect(properties.min_pointsize).to eql(1)
    end

    it 'uses half max point as min default' do
      config = { 'max_pointsize' => 6 }.freeze

      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict(config)
      expect(properties.min_pointsize).to eql(3)
    end
  end
end
