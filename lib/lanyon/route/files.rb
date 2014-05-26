module Lanyon::Route::Files
  def self.registered(app)
    repo_manager = Lanyon::RepositoryManager.new(app.repo_dir)

    # CREATE
    app.post '/files/?' do
      path = request.params[:path]
      content = request.params[:content]

      repo_manager.add(path, content)
    end

    # READ
    app.get '/files', provides: [:json] do
      respond_with :files, files: files
    end

    app.get '/files/:oid', provides: [:html, :json]  do
      respond_with :editor, file: repo_manager.file(params[:oid])
    end

    app.get '/files/*/?', provides: [:html, :json]  do
      path = params[:splat].first
      respond_with :files, files: repo_manager.files.ls(path)
    end

    # UPDATE
    app.put '/files/?' do
      oid = request.params[:oid]
      path = request.params[:path]
      content = request.params[:content]

      file = repo_manager.file(oid)

      halt 501 if file.nil?

      repo_manager.move(file, path) if path && path != file.path
      repo_manager.update(file, content) if content && content != file.content
    end

    # DELETE
    app.delete '/files/?' do
      oid = request.params[:oid]

      file = repo_manager.file(oid)

      halt 501 if file.nil?

      repo_manager.delete(file)
    end
  end
end
