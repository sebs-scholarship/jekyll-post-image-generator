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

    it 'skip if title is empty' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => ' ' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to be_nil
    end

    it 'skip if title is nil' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => nil })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to be_nil
    end

    it 'skip if cover image is set' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test', 'cover_image' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to be_nil
    end

    it 'continue if cover image is empty' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test', 'cover_image' => '' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).not_to be_nil
    end

    it 'continue if cover image is nil' do
      site = Site.new(source_dir)
      doc = Document.new('test')
      doc.data = doc.data.merge({ 'title' => 'test', 'cover_image' => nil })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).not_to be_nil
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

    it 'use the page base name without date as the filename' do
      site = Site.new(source_dir)
      doc = Document.new('2022-10-05-5-test1')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to end_with('/5-test1.jpg')
    end

    it 'use the page base name as the filename when date absent' do
      site = Site.new(source_dir)
      doc = Document.new('5-test1')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.output_path).to end_with('/5-test1.jpg')
    end

    it 'use the page title as the image text' do
      site = Site.new(source_dir)
      doc = Document.new('test1')
      doc.data = doc.data.merge({ 'title' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.image_text).to eql('test')
    end

    it 'use the page cover image text override as the image text when present' do
      site = Site.new(source_dir)
      doc = Document.new('test1')
      doc.data = doc.data.merge({ 'title' => 'test1', 'cover_image_text' => 'test2' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.image_text).to eql('test2')
    end

    it 'use the page cover image text override as the image text when title absent' do
      site = Site.new(source_dir)
      doc = Document.new('test1')
      doc.data = doc.data.merge({ 'cover_image_text' => 'test' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.image_text).to eql('test')
    end

    it 'unescapes special formatting characters' do
      site = Site.new(source_dir)
      doc = Document.new('test1')
      doc.data = doc.data.merge({ 'cover_image_text' => 'test1\ntest2\ntest3\\\test4' })
      site.posts.docs << doc
      generator = Jekyll::JekyllPostImageGenerator::MockImageGenerator.new(SOURCE_IMG)
      processor = Jekyll::JekyllPostImageGenerator::SiteProcessor.new({}, generator)
      processor.process(site)
      expect(generator.image_text).to eql("test1\ntest2\ntest3\\test4")
    end
  end
end
