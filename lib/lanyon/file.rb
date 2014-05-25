class Lanyon::File
  attr_accessor :path, :content
  attr_reader :oid

  def initialize(root, path, oid, content = nil)
    @root = root
    @path = path
    @oid = oid
    @content = content || read
  end

  def system_path
    File.join(@root, @path)
  end

  def basename
    File.basename(@path)
  end

  def dirname
    File.dirname(@path)
  end

  def exists?
    File.exist?(system_path)
  end

  def read
    File.read(system_path) if ::File.file?(system_path)
  end

  def write
    File.write(system_path, @content)
  end

  def move(path)
    File.rename(system_path, File.join(@root, path))
    @path = path
  end

  def eql?(other)
    to_h.eql?(other.to_h)
  end

  def to_h
    { oid: @oid,
      path: @path,
      content: @content }
  end

  def to_json(*)
    to_h.to_json
  end
end
