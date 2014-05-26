class Lanyon::Directory < Lanyon::FileObject
  def initialize(path, oid, repository, content = false)
    super(path, oid, repository.workdir, content)
    @repo = repository

    if content
      tree = (path == '') ? root_tree : @repo.lookup(oid)
      @content = tree.map do |hash|
        hash[:path] = (path == '') ? hash[:name] : File.join(path, hash[:name])
        hash_to_lanyon_class(hash)
      end.compact
    end
  end

  def root_tree
    @repo.lookup(@repo.head.target).tree
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
end
