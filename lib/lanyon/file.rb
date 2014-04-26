require 'pathname'

class Lanyon::File
  attr_accessor :path

  def initialize(path)
    @path = Pathname.new(path).absolute? ? path : File.join('.', path)
  end

  def basename
    File.basename(@path)
  end

  def dirname
    File.dirname(@path)
  end

  def file?
    File.file?(@path)
  end

  def directory?
    File.directory?(@path)
  end
end
