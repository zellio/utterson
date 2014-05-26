class Lanyon::Directory < Lanyon::FileObject
  def initialize(path, oid, repository, content = false)
    super(path, oid, repository.workdir, content)
    @repo = repository
  end

  def root_tree
    @repo.lookup(@repo.head.target).tree
  end
  private :root_tree

  def hash_to_lanyon_class(hash)
    case hash[:type]
    when :blob
      Lanyon::File.new(@repo.workdir, hash[:path], hash[:oid])
    when :tree
      Lanyon::Directory.new(hash[:path], hash[:oid], @repo)
    end
  end
  private :hash_to_lanyon_class

  def content
    return @content unless @content
    tree = (path == '') ? root_tree : @repo.lookup(root_tree.path(path)[:oid])
    tree.map do |hash|
      hash[:path] = (path == '') ? hash[:name] : File.join(path, hash[:name])
      hash_to_lanyon_class(hash)
    end.compact
  end
end
