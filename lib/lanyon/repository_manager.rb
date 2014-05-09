require 'pathname'
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

  def files
    @file_collection ||= Lanyon::FileCollection.new(repo.index)
  end

  def file(oid)
    files.get(oid)
  end

  def commit(message)
    tree_oid = @repo.index.write_tree
    @repo.index.write

    Rugged::Commit.create(@repo, {
      tree: tree_oid,
      author: author,
      committer: author,
      message: "#{name} is #{message}",
      parents: @repo.empty? ? [] : [@repo.head.target].compact,
      update_ref: 'HEAD'
    })
  end

  def add(file)
    commit("creating a new file at <#{file.path}>")
  end

  def update(file, contents)
    file.contents = contents
    @repo.index.update(file.git_path)

    commit("updating <#{file.path}> with new content")
  end

  def move(file, path)
    @repo.index.remove(file.path)
    old_path, file.path = file.path, path
    @repo.index.add(file.path)

    commit("moving <#{old_path}> to <#{file.path}>")
  end

  def delete(file)
    file.delete
    @repo.index.remove(file.git_path)

    commit("deleting <#{file.path}>")
  end
end
