class Lanyon::Directory < Lanyon::FileObject
  def initialize(path, oid, repository, content = false)
    super(path, oid, repository.workdir, content)
    @repo = repository
    @path = path

    read if content
  end

  def root_tree
    @repo.last_commit.tree
  end
  private :root_tree

  def hash_to_lanyon_class(hash)
    case hash[:type]
    when :blob
      Lanyon::File.new(hash[:path], hash[:oid], @repo.workdir, true)
    when :tree
      Lanyon::Directory.new(hash[:path], hash[:oid], @repo, false)
    end
  end
  private :hash_to_lanyon_class

  def read
    tree = @path.empty? ? root_tree : @repo.lookup(oid)
    @content = tree.map do |hash|
      hash[:path] = (path == '') ? hash[:name] : File.join(path, hash[:name])
      hash_to_lanyon_class(hash)
    end.compact
  end

  def to_h
    super.to_h.merge(type: :directory)
  end
end
