# frozen_string_literal: true

module Jekyll
  # Creates Liquid tag that returns the path to the generated image for a post
  class ImageTag < Liquid::Tag
    def render(context)
      site = context.registers[:site]

      post = get_post(site, context)

      return nil if post.nil?

      return post.data['cover_image'] if post.data.key?('cover_image')

      image_path = create_path(output_dir(site.config), post)

      return "/#{image_path}" if File.exist?(image_path)

      nil
    end

    private

    def get_post(site, context)
      site.posts.docs.detect { |p| p.path == File.expand_path(context['page']['path']) }
    end

    def create_path(dir, post)
      File.join(dir, "#{post.basename_without_ext.sub(/^\d\d\d\d-\d\d-\d\d-/, '')}.jpg")
    end

    def output_dir(config)
      Utils.deep_merge_hashes(
        JekyllPostImageGenerator::DEFAULTS,
        config.fetch('jekyll-post-image-generator', {})
      )['output_directory']
    end
  end
end

Liquid::Template.register_tag('generated_image_path', Jekyll::ImageTag)
