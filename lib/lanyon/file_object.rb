class Lanyon::FileObject
  include ::Comparable

  attr_reader :path, :oid, :content, :repo_root

  def initialize(path, oid, repo_root = '', content = false)
    @path = path
    @oid = oid
    @repo_root = repo_root
    @content = content
  end

  def system_path
    File.join(@repo_root, @path)
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

  def file?
    File.file?(system_path)
  end

  def directory?
    File.directory?(system_path)
  end

  def mode
    ::File::Stat.new(system_path).mode
  end

  def flush_content
    @content = nil
  end

  def to_h
    hash = { oid: @oid, path: @path, type: :file_object }
    hash[:content] = @content if @content
    hash
  end

  def eql?(other)
    to_h.eql?(other.to_h)
  end

  def to_json(*)
    ::MultiJson.encode(to_h)
  end

  def <=>(o)
    return basename <=> o.basename if directory? && o.directory?
    return -1 if directory? && o.file?
    return 1 if file? && o.directory?
    return basename <=> o.basename if file? && o.file?
  end
end
