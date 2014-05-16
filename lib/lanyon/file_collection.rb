class Lanyon::FileCollection # < ::Array
  def initialize(repository)
    @repo = repository
  end

  def root_tree
    @repo.lookup(@repo.head.target).tree
  end

  def hash_to_lanyon_class(hash)
    case hash[:type]
    when :blob
      Lanyon::File.new(@repo.workdir, hash[:path], hash[:oid])
    when :tree
      hash[:path]
    end
  end
  private :hash_to_lanyon_class

  def ls(path)
    tree = path == "" ? root_tree : @repo.lookup(root_tree.path(path)[:oid])
    tree.map do |hash|
      hash[:path] = File.join(path, hash[:name])
      hash_to_lanyon_class(hash)
    end.compact
  end

  def get(oid)
    data = @repo.index.find { |entry| entry[:oid] == oid }.merge(type: :blob)
    hash_to_lanyon_class(data)
  end

  def to_json(*)
    @repo.index.map do |data|
      Lanyon::File.new(@repo.workdir, data[:path], data[:oid])
    end.to_json
  end
end
