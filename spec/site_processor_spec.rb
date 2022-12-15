# frozen_string_literal: true

require 'spec_helper'
require 'mocks/image_generator'
require 'mocks/jekyll'

describe(Jekyll::JekyllPostImageGenerator::SiteProcessor) do
  context 'when loading config' do
    it 'use the default output path' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      path = Jekyll::JekyllPostImageGenerator::DEFAULTS['output_directory']
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)

      expect(generator.output_path).to eql(File.join(path, 'test.jpg'))
    end

    it 'use the provided output path' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      path = 'test1/test2'
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({ 'output_directory' => path }, generator)
      processor.process(site)
      expect(generator.output_path).to eql(File.join(path, 'test.jpg'))
    end
  end

  context 'when generating a page' do
    it 'skip if title is not present' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to be_nil
    end

    it 'skip if cover image is set' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test', 'cover_img' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to be_nil
    end

    it 'skip if image already exists' do
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      mk_tmp_file('test', '.jpg') do |path|
        site = Site.new(source_dir)
        doc = Document.new(basename(path))
        doc.data = doc.data.merge({ 'title' => 'test' })
        site.posts.docs << doc
        processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new(
          { 'output_directory' => dirname(path) },
          generator
        )
        processor.process(site)
      end
      expect(generator.output_path).to be_nil
    end

    it 'use the page base name as the filename' do
      site = Site.new(source_dir)
      doc = Document.new('test1')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to end_with('/test1.jpg')
    end
  end
end
