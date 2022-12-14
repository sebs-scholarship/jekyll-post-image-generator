# frozen_string_literal: true

class Page < Jekyll::Page
  def initialize(basename, data)
    @basename = basename
    @data = data
  end
end

class Document
  attr_accessor :basename_without_ext
  attr_writer :data

  def initialize(basename_without_ext)
    @basename_without_ext = basename_without_ext
  end

  def data
    @data ||= {}
  end
end

class Collection
  def docs
    @docs ||= []
  end
end

class Site
  attr_accessor :source

  def initialize(source)
    @source = source
  end

  def posts
    @posts ||= Collection.new
  end

  def static_files
    @static_files ||= []
  end
end
