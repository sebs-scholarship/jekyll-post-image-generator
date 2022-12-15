# frozen_string_literal: true

require 'fileutils'

module Jekyll
  module JekyllPostImageGenerator
    # Jekyll generator entry point
    class Generator < Jekyll::Generator
      safe true

      def initialize(
        config = {},
        processor = nil
      )
        super(config)
        @config = Utils.deep_merge_hashes(
          DEFAULTS,
          config.fetch('jekyll-post-image-generator', {})
        )
        @processor = processor.nil? ? SiteProcessor.new(config) : processor
      end

      def generate(site)
        output_dir = @config.fetch('output_directory', File.join('assets', 'images', 'title_images'))
        FileUtils.mkdir_p(output_dir) unless File.exist?(output_dir)
        @processor.process(site)
      end
    end
  end
end
