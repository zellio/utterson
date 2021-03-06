require 'fileutils'
require 'rugged'

class Utterson::RepositoryManager
  include Utterson::Conversion

  def initialize(path, email = 'utterson@localhost', name = 'Dr. Utterson')
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
      base_tree.path(path).merge(name: path)
    end
  end
  private :object_data

  def get(path)
    data = object_data(path)
    hash_to_utterson_class(data)
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

  def add(file, content)
    oid = @repo.write(content, :blob)

    file.oid = oid
    file.content = content
    file.write

    @repo.index.add(path: file.path, oid: file.oid, mode: 0100644)

    commit("creating new file: #{file.path}")
  end

  def update(file, content)
    return unless file.exists?

    file.content = content
    file.write

    @repo.index.update(file.path)

    commit("updating <#{file.path}> with new content")
  end

  def move(file, target)
    return if get(target)

    oid = @repo.write(file.read, :blob)

    file.move(target)

    @repo.index.add(path: target, oid: oid, mode: file.mode)
    @repo.index.remove(file.path)

    commit("moving <#{file.path}> to <#{target}>")
  end

  def delete(file)
    file.delete

    @repo.index.remove(file.path)

    commit("deleting <#{file.path}>")
  end
end
