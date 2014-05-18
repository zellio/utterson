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

  def file?
    File.file?(system_path)
  end

  def directory?
    File.directory?(system_path)
  end

  def exists?
    File.exists?(system_path)
  end

  def read
    File.read(system_path) if file?
  end

  def write
    File.write(system_path, @content)
  end

  def move(path)
    File.rename(system_path, File.join(@root, path))
    @path = path
  end

  def to_json(_state)
    { oid: @oid,
      path: @path,
      content: @content }.to_json
  end
end
