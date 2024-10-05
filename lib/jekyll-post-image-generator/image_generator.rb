# frozen_string_literal: true

require 'mini_magick'

module Jekyll
  module JekyllPostImageGenerator
    # Configuration properties for generated image fonts
    class ImageGeneratorFontProperties
      def initialize(
        max_pointsize: 200,
        min_pointsize: nil,
        font: 'montserrat-Light',
        font_color: 'white'
      )
        @max_pointsize = max_pointsize
        @min_pointsize = min_pointsize
        @font_color = font_color
        @font = font
      end

      attr_accessor :max_pointsize, :font, :font_color
      attr_writer :min_pointsize

      def min_pointsize
        !@min_pointsize.nil? ? @min_pointsize : @max_pointsize / 2
      end

      def self.new(*args)
        instance = super(*args)

        if block_given?
          yield instance
        else
          instance
        end
      end

      def self.from_hash(params)
        ImageGeneratorFontProperties.new do |properties|
          properties.max_pointsize = params['max_pointsize'] if params.key?('max_pointsize')
          properties.min_pointsize = params['min_pointsize'] if params.key?('min_pointsize')
          properties.font = params['font'] if params.key?('font')
          properties.font_color = params['font_color'] if params.key?('font_color')

          properties
        end
      end
    end

    # Configuration properties for generated images
    class ImageGeneratorImageProperties
      def initialize(
        image_path: nil,
        image_color: '#2054df',
        image_size: '2048x1024',
        max_chars_per_line: 30
      )
        @image_path = image_path
        @image_color = image_color
        @image_size = image_size
        @max_chars_per_line = max_chars_per_line
      end

      attr_accessor :image_path, :image_color, :image_size, :max_chars_per_line

      def self.new(*args)
        instance = super(*args)

        if block_given?
          yield instance
        else
          instance
        end
      end

      def self.from_hash(params)
        ImageGeneratorImageProperties.new do |properties|
          properties.image_path = params['image_path'] if params.key?('image_path')
          properties.image_color = params['image_color'] if params.key?('image_color')
          properties.image_size = params['image_size'] if params.key?('image_size')
          properties.max_chars_per_line = params['max_chars_per_line'] if params.key?('max_chars_per_line')

          properties
        end
      end
    end

    # Configuration properties container
    class ImageGeneratorProperties
      def initialize(
        image_properties: nil,
        font_properties: nil
      )
        @image_properties = image_properties || ImageGeneratorImageProperties.new
        @font_properties = font_properties || ImageGeneratorFontProperties.new
      end

      attr_accessor :image_properties, :font_properties

      def self.new(*args, **kwargs)
        instance = super(*args, **kwargs)

        if block_given?
          yield instance
        else
          instance
        end
      end

      def self.from_hash(params)
        ImageGeneratorProperties.new(
          image_properties: ImageGeneratorImageProperties.from_hash(params),
          font_properties: ImageGeneratorFontProperties.from_hash(params)
        )
      end
    end

    # Generates images with text from a background image
    class ImageGenerator
      def initialize(
        properties
      )
        @properties = properties
      end

      def generate(image_text, output_path)
        lines = break_long_lines(image_text.strip.squeeze(' ').lines.map(&:chomp))
        pointsize = get_font_size_for_lines(lines)
        create_image(lines.join("\n"), pointsize, output_path)
      end

      private

      def setup_base_image(magick)
        if !@properties.image_properties.image_path.nil?
          magick << @properties.image_properties.image_path
        else
          magick.size(@properties.image_properties.image_size).canvas(@properties.image_properties.image_color)
        end

        magick
      end

      def create_image(text, pointsize, output_path)
        MiniMagick::Tool.new('convert') do |magick|
          setup_base_image(magick).gravity('center').fill(@properties.font_properties.font_color).pointsize(pointsize)\
                                  .font(@properties.font_properties.font).annotate('+0+0', text)

          magick << output_path
        end
      end

      def break_long_lines(lines)
        new_lines = []

        lines.each do |line|
          if line.length <= @properties.image_properties.max_chars_per_line
            new_lines << line
          else
            new_lines.concat(word_wrap(line))
          end
        end

        new_lines
      end

      def word_wrap(text)
        return [text] if text.length <= @properties.image_properties.max_chars_per_line

        lines = []

        line_end = get_wrap_location(text)

        lines << text[0..line_end - 1]
        lines.concat(word_wrap(text[line_end..text.length].strip))

        lines
      end

      def get_wrap_location(text)
        index = 0
        line_end = @properties.image_properties.max_chars_per_line
        while index < @properties.image_properties.max_chars_per_line
          line_end = index if text[index] == ' '
          index += 1
        end

        line_end
      end

      def get_font_size_for_lines(lines)
        return @properties.font_properties.max_pointsize if lines.empty?

        size = get_font_size_for_columns(lines[0].length)

        lines.each do |line|
          line_size = get_font_size_for_columns(line.length)
          size = line_size unless line_size >= size
        end

        size
      end

      def font_size_slope
        -1.0 * (@properties.font_properties.max_pointsize / @properties.image_properties.max_chars_per_line.to_f)
      end

      def get_font_size_for_columns(columns)
        constant = @properties.font_properties.min_pointsize
        offset = @properties.image_properties.max_chars_per_line
        font_size = font_size_slope * (columns - offset) + constant

        return @properties.font_properties.max_pointsize if font_size > @properties.font_properties.max_pointsize

        font_size.to_i
      end
    end
  end
end
