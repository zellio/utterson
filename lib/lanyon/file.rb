class Lanyon::File < ::File
  def initialize(opts={})
    @path = opts[:path]
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
