# frozen_string_literal: true

require 'spec_helper'
require 'overwrites/tool'

describe(Jekyll::JekyllPostImageGenerator::ImageGenerator) do
  context 'when creating an image' do
    it 'uses the correct input file name' do
      params = { 'image_path' => 'test' }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_first(last_command)).to eql('test')
    end

    it 'uses the correct output file name' do
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.new
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_last(last_command)).to eql('dest')
    end

    it 'uses the proper font' do
      params = { 'font' => 'test' }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-font')).to eql('test')
    end

    it 'uses the proper color fill' do
      params = { 'font_color' => 'test' }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-fill')).to eql('test')
    end

    it 'uses the proper gravity' do
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.new
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-gravity')).to eql('center')
    end

    it 'uses the proper pointsize for 15 chars @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(15), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('200')
    end

    it 'uses the proper pointsize for 30 chars @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(30), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('100')
    end

    it 'uses the proper pointsize for 20 chars @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(20), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses the proper pointsize for 10 chars @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(10), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('200')
    end

    it 'uses the proper pointsize for 35 chars @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(35), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('100')
    end

    it 'uses the proper pointsize for 36 chars (20 space 15) @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate("#{make_string(20)} #{make_string(15)}", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses the proper pointsize for 36 chars (15 space 20) @ 30 chars max, 200pt max, 100pt min' do
      params = { 'max_pointsize' => 200, 'min_pointsize' => 100, 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate("#{make_string(15)} #{make_string(20)}", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses two wrapped lines for 35 chars @ 30 chars max' do
      params = { 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(35), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("#{make_string(30)}\n#{make_string(5)}")
    end

    it 'uses three wrapped lines for 65 chars @ 30 chars max' do
      params = { 'max_chars_per_line' => 30 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(65), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to\
        eql("#{make_string(30)}\n#{make_string(30)}\n#{make_string(5)}")
    end

    it 'wraps on word break if possible for 25 chars @ 10 chars max' do
      params = { 'max_chars_per_line' => 10 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate("#{make_string(5)} #{make_string(19)} #{make_string(1)}", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to\
        eql("#{make_string(5)}\n#{make_string(10)}\n#{make_string(9)}\n#{make_string(1)}")
    end

    it 'does not start newline on a space for 10 chars @ 5 chars max' do
      params = { 'max_chars_per_line' => 5 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate("#{make_string(5)} #{make_string(5)}", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("#{make_string(5)}\n#{make_string(5)}")
    end

    it 'respects line breaks for 10 chars @ 5 chars max' do
      params = { 'max_chars_per_line' => 5 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate("#{make_string(2)}\n#{make_string(8)}", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to\
        eql("#{make_string(2)}\n#{make_string(5)}\n#{make_string(3)}")
    end

    it 'removes extra whitespace' do
      params = { 'max_chars_per_line' => 10 }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(" #{make_string(5)}    #{make_string(19)}           #{make_string(1)} ", 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to\
        eql("#{make_string(5)}\n#{make_string(10)}\n#{make_string(9)}\n#{make_string(1)}")
    end

    it 'centers text' do
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.new
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate(make_string(10), 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-annotate')).to eql('+0+0')
    end

    it 'generates an image with provided color' do
      params = { 'image_path' => nil, 'image_color' => 'test' }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_first(last_command)).to eql('canvas:test')
    end

    it 'generates an image with provided size' do
      params = { 'image_path' => nil, 'image_size' => 'test' }
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_hash(params)
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(properties)
      generator.generate('', 'dest')
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-size')).to eql('test')
    end
  end
end
