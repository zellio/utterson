require 'rugged'

module Lanyon::Route::Files
  def self.registered(app)
    repo = Rugged::Repository.new(app.repo_dir)
    fc = Lanyon::FileCollection.new(repo.index)

    author = {
      email: 'lanyon@localhost.localhost',
      name: 'Dr. Lanyon',
      time: Time.now
    }

    # CREATE
    app.post '/files/?' do
    end

    # READ
    app.get '/files/*/?:id?', provides: [:html, :json] do
      respond_with :editor, file: fc.get(params[:id]) unless params[:id].nil?

      path = params[:splat].first
      path = path.empty? ? '.' : File.join('.', path)

      respond_with :files, files: fc.ls(path)
    end

    # UPDATE
    app.put '/files/?' do
      oid = request.params[:oid]
      path = request.params[:path]
      basename = request.params[:basename]
      dirname = request.params[:dirname]
      contents = request.params[:contents]

      file = fc.get(oid)

      halt 501 if oid.nil? || file.nil?

      if path.nil?
        path = if dirname && basename
                 File.join(dirname, basename)
               elsif dirname && basename.nil?
                 File.join(dirname, file.basename)
               elsif dirname.nil? && basename
                 File.join(file.dirname, basename)
               end
      end

      if file.path != path
        # move the file
      end

      if file.contents != contents
        tree = repo.index.write_tree

        file.contents = contents
        repo.index.add(file.path)

        Rugged::Commit.create(repo, {
          tree: tree,
          author: author,
          committer: author,
          message: "Dr. Lanyon is updating <#{file.path}> with new content",
          parents: repo.empty? ? [] : [repo.head.target].compact,
          update_ref: 'HEAD'
        })
      end
    end

    # DELETE
    app.delete '/files/?' do
    end
  end
end
