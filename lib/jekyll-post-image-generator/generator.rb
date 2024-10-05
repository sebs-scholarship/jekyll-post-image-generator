# frozen_string_literal: true

require 'fileutils'

module Jekyll
  module JekyllPostImageGenerator
    # Jekyll generator entry point
    class Generator < Jekyll::Generator
      safe true

      def initialize(
        config = {},
        processor: nil
      )
        super(config)

        @config = config.fetch('jekyll-post-image-generator', {})

        @processor = if !processor.nil?
                       processor
                     else
                       SiteProcessor.new(
                         @config.fetch('output_directory', nil),
                         ImageGenerator.new(ImageGeneratorProperties.from_hash(@config))
                       )
                     end
      end

      def generate(site)
        FileUtils.mkdir_p(@processor.output_dir) unless File.exist?(@processor.output_dir)
        @processor.process(site)
      end
    end
  end
end
