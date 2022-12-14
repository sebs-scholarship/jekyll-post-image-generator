# frozen_string_literal: true

require 'mini_magick'

module JekyllPostImageGenerator
  # Configuration properties for image generation
  class ImageGeneratorProperties
    def initialize(
      max_columns_per_line: 30,
      max_pointsize: 200,
      min_pointsize: max_pointsize / 2,
      font: 'montserrat-Thin',
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
        properties.min_pointsize = params.fetch('min_pointsize', 100)
        properties.font = params.fetch('font', 'montserrat-Thin')
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
      pointsize = get_pointsize_for_columns(image_text.length)
      lines = word_wrap(image_text)
      positions = get_line_positions(pointsize, lines.length)
      create_image(lines, positions, pointsize, output_path)
    end

    private

    def create_image(lines, positions, pointsize, output_path)
      MiniMagick::Tool::Magick.new do |magick|
        magick << @base_image
        magick.gravity('center').fill(@properties.font_color).pointsize(pointsize).font(@properties.font)

        positions.each_with_index do |position, index|
          magick.annotate("+0#{position_string(position)}", lines[index])
        end

        magick << output_path
      end
    end

    def position_string(position)
      position.negative? ? position.to_s : "+#{position}"
    end

    def word_wrap(text)
      position = 0
      lines = []
      while position < text.length
        lines.append(text[position, @properties.max_columns_per_line])
        position += @properties.max_columns_per_line
      end

      lines
    end

    def get_line_positions(pointsize, lines)
      positions = []
      index = 0

      offset = (pointsize / 2) * ((lines - 1) % 2)
      start = offset - (lines / 2 * pointsize)
      while index < lines
        positions.append(start)
        start += pointsize
        index += 1
      end

      positions
    end

    def get_pointsize_for_columns(columns)
      return @properties.max_pointsize if columns <= @properties.min_pointsize_limit

      return @properties.min_pointsize if columns >= @properties.max_columns_per_line

      (@properties.min_pointsize + (@properties.max_columns_per_line - columns) * @properties.pointsize_slope).to_i
    end
  end
end
