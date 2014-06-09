class Lanyon::FileObject
  attr_reader :path, :oid, :content

  def initialize(path, oid, system_root = '', content = false)
    @path = path
    @oid = oid
    @system_root = system_root
    @content = content
  end

  def system_path
    File.join(@system_root, @path)
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

  def flush_content
    @content = false
  end

  def to_h
    hash = { oid: @oid, path: @path }
    hash[:content] = @content if @content
    hash
  end

  def eql?(other)
    to_h.eql?(other.to_h)
  end

  def to_liquid
    to_h.reduce({}) do |hash, kv_pair|
      key, val = *kv_pair
      hash[key.to_s] = val
      hash
    end
  end

  def to_json(*)
    to_h.to_json
  end
end
