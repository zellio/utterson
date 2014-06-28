require 'fileutils'
require 'rugged'

class Lanyon::RepositoryManager
  attr_reader :repo

  def initialize(path, email = 'lanyon@localhost', name = 'Dr. Lanyon')
    @path = path
    @email = email
    @name = name
    @repo = Rugged::Repository.new(path)
  end

  def author
    { email: @email, name: @name, time: Time.now }
  end

  def object_data(path)
    base_tree = @repo.last_commit.tree

    if path.empty?
      { name: '',
        oid: base_tree.oid,
        filemode: ::File.stat(@repo.workdir).mode,
        type: :tree }
    else
      base_tree.path(path)
    end

  end
  private :object_data

  def hash_to_lanyon_class(hash)
    case hash[:type]
    when :blob
      Lanyon::File.new(hash[:name], hash[:oid], @repo.workdir, true)
    when :tree
      Lanyon::Directory.new(hash[:name], hash[:oid], @repo, false)
    end
  end
  private :hash_to_lanyon_class

  def get(path)
    data = object_data(path)
    hash_to_lanyon_class(data)
  rescue
    nil
  end

  alias_method :file, :get

  alias_method :directory, :get

  def commit(message)
    tree_oid = @repo.index.write_tree
    @repo.index.write

    commit_parents = @repo.empty? ? [] : [@repo.head.target].compact

    Rugged::Commit.create(@repo,
                          tree: tree_oid,
                          author: author,
                          committer: author,
                          message: "#{@name} is #{message}",
                          parents: commit_parents,
                          update_ref: 'HEAD')
  end
  private :commit

  def add(path, content)
    return if get(path)

    oid = @repo.write(content, :blob)
    file = Lanyon::File.new(path, oid, @repo.workdir)

    file.content = content
    file.write unless file.exists?

    @repo.index.add(path: file.path, oid: file.oid, mode: 0100644)

    commit("creating new file: #{file.path}")
  end

  def update(path, content)
    file = get(path)

    return if file.nil?

    file.content = content
    file.write

    @repo.index.update(file.path)

    commit("updating <#{file.path}> with new content")
  end

  def move(path, target)
    file = get(path)
    return unless file && get(target).nil?

    target_path = ::File.join(@repo.workdir, target)
    FileUtils.mkdir_p(::File.dirname(target_path))

    file.move(target)

    @repo.index.remove(path)
    @repo.index.add(target)

    commit("moving <#{path}> to <#{target}>")
  end

  def delete(file)
    file.delete

    @repo.index.remove(file.path)

    commit("deleting <#{file.path}>")
  end
end
