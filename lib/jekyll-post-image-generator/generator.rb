# frozen_string_literal: true

require 'jekyll-post-image-generator/site_processor'

module JekyllPostImageGenerator
  # Jekyll generator entry point
  class Generator < Jekyll::Generator
    safe true
    priority :normal

    def initialize(
      config = {},
      processor = SiteProcessor.new(
        Utils.deep_merge_hashes(
          DEFAULTS,
          config.fetch('jekyll-post-image-generator', {})
        )
      )
    )
      super(config)
      @processor = processor
    end

    def generate(site)
      processor.process(site)
    end
  end
end
