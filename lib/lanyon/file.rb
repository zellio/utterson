class Lanyon::File < Lanyon::FileObject
  attr_accessor :content

  def initialize(path, oid, repo_root = '', content = false)
    super
    @content = read if @content
  end

  def read
    File.read(system_path) if file?
  end

  def write
    ::File.write(system_path, @content) if @content
  end

  def move(path)
    ::File.rename(system_path, ::File.join(@repo_root, path))
    @path = path
  end

  def delete
    ::File.delete(system_path)
  end
end
