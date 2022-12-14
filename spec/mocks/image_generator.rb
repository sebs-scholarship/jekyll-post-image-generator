# frozen_string_literal: true

class ImageGenerator < JekyllPostImageGenerator::ImageGenerator
  def generate(image_text, output_path)
    @image_text = image_text
    @output_path = output_path
  end

  attr_accessor :image_text, :output_path
end
