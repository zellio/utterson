require 'pathname'

class Lanyon::File
  attr_accessor :path, :content
  attr_reader :oid

  def initialize(root, path, oid, content = nil)
    @root = root
    @path = path
    @oid = oid
    @content = content || read
  end

  def web_path
    File.join('.', @path)
  end

  def full_path
    File.join(@root, @path)
  end

  def basename
    File.basename(web_path)
  end

  def dirname
    File.dirname(web_path)
  end

  def file?
    File.file?(full_path)
  end

  def directory?
    File.directory?(full_path)
  end

  def read
    File.read(full_path) if file?
  end

  def write
    File.open(full_path, 'w') { |f| f.write(content) } if file?
  end

  def move(path)
    File.rename(full_path, File.join(@root, path))
    @path = path
  end

  def to_json(state)
    { oid: @oid,
      path: @path,
      content: content }.to_json
  end
end
