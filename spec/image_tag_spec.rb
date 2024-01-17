# frozen_string_literal: true

require 'fileutils'
require 'tempfile'
require 'spec_helper'
require 'mocks/liquid'

describe(Jekyll::JekyllPostImageGenerator::ImageGenerator) do
  context 'when post image is rendered' do
    it 'should return path to image' do
      site = Site.new(source_dir)
      output_dir = Jekyll::JekyllPostImageGenerator::DEFAULTS['output_directory']
      expanded = File.expand_path(output_dir)
      FileUtils.mkdir_p(expanded)
      file = Tempfile.new(['', '.jpg'], expanded)

      begin
        file.close
        path = file.path
        raise('Temp file not created properly') if path.nil?

        name = File.basename(path)
        doc = Document.new(name[0...-4], "#{source_dir}/#{name}")
        doc.data = doc.data.merge({ 'title' => 'test' })
        site.posts.docs << doc
        parse_context = Liquid::ParseContext.new
        parse_context.line_number = 1
        image_tag = Jekyll::ImageTag.parse('', '', '', parse_context)
        context = Context.new({ :site => site }, { 'page' => { 'path' => "#{source_dir}/#{name}" } }) # rubocop:disable Style/HashSyntax

        expect(image_tag.render(context)).to eql("/#{output_dir}/#{name}")
      ensure
        file.unlink
      end
    end
  end

  context 'when post image is not rendered' do
    it 'should return nil' do
      site = Site.new(source_dir)
      doc = Document.new('test', "#{source_dir}/test-path")
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      parse_context = Liquid::ParseContext.new
      parse_context.line_number = 1
      image_tag = Jekyll::ImageTag.parse('', '', '', parse_context)
      context = Context.new({ :site => site }, { 'page' => { 'path' => "#{source_dir}/test-path" } }) # rubocop:disable Style/HashSyntax

      expect(image_tag.render(context)).to be_nil
    end
  end

  context 'when post cover image path is supplied' do
    it 'should return supplied path' do
      site = Site.new(source_dir)
      doc = Document.new('test', "#{source_dir}/test-path")
      doc.data = doc.data.merge({ 'title' => 'test', 'cover_image' => 'test-cover-image' })
      site.posts.docs << doc
      parse_context = Liquid::ParseContext.new
      parse_context.line_number = 1
      image_tag = Jekyll::ImageTag.parse('', '', '', parse_context)
      context = Context.new({ :site => site }, { 'page' => { 'path' => "#{source_dir}/test-path" } }) # rubocop:disable Style/HashSyntax

      expect(image_tag.render(context)).to eql('test-cover-image')
    end
  end

  context 'when page is rendered' do
    it 'should return nil' do
      site = Site.new(source_dir)
      parse_context = Liquid::ParseContext.new
      parse_context.line_number = 1
      image_tag = Jekyll::ImageTag.parse('', '', '', parse_context)
      context = Context.new({ :site => site }, { 'page' => { 'path' => "#{source_dir}/test-path" } }) # rubocop:disable Style/HashSyntax

      expect(image_tag.render(context)).to be_nil
    end
  end
end
