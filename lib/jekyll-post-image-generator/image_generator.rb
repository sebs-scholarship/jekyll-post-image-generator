# frozen_string_literal: true

require 'mini_magick'

module Jekyll
  module JekyllPostImageGenerator
    # Configuration properties for image generation
    class ImageGeneratorProperties
      def initialize(
        max_columns_per_line: 30,
        max_pointsize: 200,
        min_pointsize: max_pointsize / 2,
        font: 'montserrat-Light',
        font_color: 'white'
      )
        @max_pointsize = max_pointsize
        @min_pointsize = min_pointsize
        @max_columns_per_line = max_columns_per_line
        @font_color = font_color
        @font = font
      end

      attr_accessor :max_columns_per_line, :max_pointsize, :min_pointsize, :font, :font_color

      def pointsize_slope
        (@max_pointsize - @min_pointsize) / (@max_columns_per_line - min_pointsize_limit).to_f
      end

      def min_pointsize_limit
        @max_columns_per_line * @min_pointsize / @max_pointsize
      end

      def self.new(*args)
        instance = super(*args)

        if block_given?
          yield instance
        else
          instance
        end
      end

      def self.from_dict(params)
        ImageGeneratorProperties.new do |properties|
          properties.max_columns_per_line = params.fetch('max_columns_per_line', 30)
          properties.max_pointsize = params.fetch('max_pointsize', 200)
          properties.min_pointsize = params.fetch('min_pointsize', properties.max_pointsize / 2)
          properties.font = params.fetch('font', 'montserrat-Light')
          properties.font_color = params.fetch('font_color', 'white')

          properties
        end
      end
    end

    # Generates images with text from a background image
    class ImageGenerator
      def initialize(
        base_image_path,
        properties = ImageGeneratorProperties.new
      )
        @base_image = base_image_path
        @properties = properties
      end

      def generate(image_text, output_path)
        lines = break_long_lines(image_text.strip.squeeze(' ').lines.map(&:chomp))
        pointsize = get_pointsize_for_lines(lines)
        create_image(lines.join("\n"), pointsize, output_path)
      end

      private

      def create_image(text, pointsize, output_path)
        MiniMagick::Tool::Magick.new do |magick|
          magick << @base_image

          magick.gravity('center').fill(@properties.font_color).pointsize(pointsize).font(@properties.font)\
                .annotate('+0+0', text)

          magick << output_path
        end
      end

      def break_long_lines(lines)
        new_lines = []

        lines.each do |line|
          if line.length <= @properties.max_columns_per_line
            new_lines << line
          else
            new_lines.concat(word_wrap(line))
          end
        end

        new_lines
      end

      def word_wrap(text)
        return [text] if text.length <= @properties.max_columns_per_line

        lines = []

        line_end = get_wrap_location(text)

        lines << text[0..line_end - 1]
        lines.concat(word_wrap(text[line_end..text.length].strip))

        lines
      end

      def get_wrap_location(text)
        index = 0
        line_end = @properties.max_columns_per_line
        while index < @properties.max_columns_per_line
          line_end = index if text[index] == ' '
          index += 1
        end

        line_end
      end

      def get_pointsize_for_lines(lines)
        return @properties.max_pointsize if lines.empty?

        size = get_pointsize_for_columns(lines[0].length)

        lines.each do |line|
          line_size = get_pointsize_for_columns(line.length)
          size = line_size unless line_size >= size
        end

        size
      end

      def get_pointsize_for_columns(columns)
        return @properties.max_pointsize if columns <= @properties.min_pointsize_limit

        return @properties.min_pointsize if columns >= @properties.max_columns_per_line

        (@properties.min_pointsize + (@properties.max_columns_per_line - columns) * @properties.pointsize_slope).to_i
      end
    end
  end
end
