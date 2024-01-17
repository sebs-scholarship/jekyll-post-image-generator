# frozen_string_literal: true

require 'spec_helper'
require 'overwrites/tool'

describe(Jekyll::JekyllPostImageGenerator::ImageGenerator) do
  context 'when creating an image' do
    it 'uses the correct input file name' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      generator.generate('', rand_dest)
      expect(get_first(MiniMagick::Tool.last_instance.command)).to eql(SOURCE_IMG)
    end

    it 'uses the correct output file name' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_last(last_command)).to eql(dest)
    end

    it 'uses the proper font' do
      dest = rand_dest
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'font' => 'test' })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, properties)
      generator.generate('', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-font')).to eql('test')
    end

    it 'uses the proper color fill' do
      dest = rand_dest
      properties = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'font_color' => 'test' })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, properties)
      generator.generate('', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-fill')).to eql('test')
    end

    it 'uses the proper gravity' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-gravity')).to eql('center')
    end

    it 'uses the proper pointsize for 15 chars @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('012345678901234', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('200')
    end

    it 'uses the proper pointsize for 30 chars @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('012345678901234567890123456789', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('100')
    end

    it 'uses the proper pointsize for 20 chars @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('01234567890123456789', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses the proper pointsize for 10 chars @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('0123456789', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('200')
    end

    it 'uses the proper pointsize for 35 chars @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('01234567890123456789012345678901234', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('100')
    end

    it 'uses the proper pointsize for 36 chars (20 space 15) @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('01234567890123456789 123456789012345', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses the proper pointsize for 36 chars (15 space 20) @ 30 chars max, 200pt max, 100pt min' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('012345678901234 67890123456789012345', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-pointsize')).to eql('166')
    end

    it 'uses two wrapped lines for 35 chars @ 30 chars max' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('01234567890123456789012345678901234', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("012345678901234567890123456789\n01234")
    end

    it 'uses three wrapped lines for 65 chars @ 30 chars max' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('01234567890123456789012345678901234567890123456789012345678901234', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to\
        eql("012345678901234567890123456789\n012345678901234567890123456789\n01234")
    end

    it 'wraps on word break if possible for 15 chars @ 10 chars max' do
      config = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'max_columns_per_line' => 10 })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, config)
      dest = rand_dest
      generator.generate('01234 6789012345678901234 6', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("01234\n6789012345\n678901234\n6")
    end

    it 'does not start newline on a space for 10 chars @ 5 chars max' do
      config = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'max_columns_per_line' => 5 })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, config)
      dest = rand_dest
      generator.generate('01234 6789', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("01234\n6789")
    end

    it 'respects line breaks for 10 chars @ 5 chars max' do
      config = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'max_columns_per_line' => 5 })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, config)
      dest = rand_dest
      generator.generate("01\n23456789", dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("01\n23456\n789")
    end

    it 'removes extra whitespace' do
      config = Jekyll::JekyllPostImageGenerator::ImageGeneratorProperties.from_dict({ 'max_columns_per_line' => 10 })
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG, config)
      dest = rand_dest
      generator.generate(' 01234    6789012345678901234           6 ', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_values(last_command, '-annotate', 2)[1]).to eql("01234\n6789012345\n678901234\n6")
    end

    it 'centers text' do
      generator = Jekyll::JekyllPostImageGenerator::ImageGenerator.new(SOURCE_IMG)
      dest = rand_dest
      generator.generate('0123456789', dest)
      last_command = MiniMagick::Tool.last_instance.command
      expect(get_opt_value(last_command, '-annotate')).to eql('+0+0')
    end
  end
end
