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
    base_tree = @repo.lookup(@repo.head.target).tree

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

  def file(path, content = true)
    data = object_data(path)
    if data[:type] == :blob
      Lanyon::File.new(path, data[:oid], @repo.workdir, content)
    end
  end

  def directory(path, content = true)
    path ||= ''

    data = object_data(path)
    if data[:type] == :tree
      Lanyon::Directory.new(path, data[:oid], @repo, content)
    end
  end

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

    @file_collection = nil
  end
  private :commit

  def add(path, content)
    oid = @repo.write(content, :blob)

    file = Lanyon::File.new(@repo.workdir, path, oid, content)
    file.write unless file.exists?

    @repo.index.add(path: file.path, oid: file.oid, mode: 0100644)

    commit("creating new file: #{file.path}")
  end

  def update(file, content)
    file.content = content
    file.write

    @repo.index.update(file.path)

    commit("updating <#{file.path}> with new content")
  end

  def move(file, path)
    old_path = file.path
    file.move(path)

    @repo.index.remove(old_path)
    @repo.index.add(file.path)

    commit("moving <#{old_path}> to <#{file.path}>")
  end

  def delete(file)
    file.delete
    @repo.index.remove(file.path)

    commit("deleting <#{file.path}>")
  end
end
