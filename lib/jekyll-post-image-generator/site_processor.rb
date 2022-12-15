# frozen_string_literal: true

require 'fileutils'

module Jekyll
  module JekyllPostImageGenerator
    # Processes the Jekyll site and generates new images for posts
    class SiteProcessor
      attr_reader :config

      def initialize(
        config = {},
        generator = ImageGenerator.new(
          config.fetch('background_image', '_background_image.png'),
          ImageGeneratorProperties.from_dict(config)
        )
      )
        @config = config
        @generator = generator
        @output_dir = config.fetch('output_directory', File.join('assets', 'images', 'title_images'))
      end

      def process(site)
        site.posts.docs.each do |doc|
          source_basename = doc.basename_without_ext
          path = output_path(source_basename)
          next unless can_generate?(doc)

          Jekyll.logger.info('Jekyll Post Image Generator:', "Generating image for #{source_basename}")
          @generator.generate(doc.data['title'], path)
          site.static_files << Jekyll::StaticFile.new(site, site.source, @output_dir, fullname(source_basename))
        end
      end

      private

      def fullname(basename)
        "#{basename}.jpg"
      end

      def output_path(basename)
        File.join(@output_dir, fullname(basename))
      end

      def can_generate?(doc)
        data = doc.data
        (!data.key?('cover_img') || data['cover_img'].strip.empty?) \
          && data.key?('title') && !File.exist?(output_path(doc.basename_without_ext))
      end
    end
  end
end
