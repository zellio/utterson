require 'pathname'

class Lanyon::File

  attr_accessor :path
  attr_reader :oid

  def initialize(path, oid)
    @path = Pathname.new(path).absolute? ? path : File.join('.', path)
    @oid = oid
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

  def contents
    @contents ||= File.read(@path)
  end

  def contents=(content)
    File.open(@path, 'w') {|f| f.write(content) }
    @contentes = content
  end
end
